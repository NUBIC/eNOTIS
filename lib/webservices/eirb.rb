
require 'webservices'
class Eirb
  # basic settings for single row queries
  SEARCH_DEFAULTS = {  :startRow => 1, 
                       :numRows => -1,
                       :expandMultiValueCells => true
                       }.freeze

  STORED_SEARCHES = [
   # {:name => "eNOTIS Person Details", :ext => "user"}, # not used currently
   # {:name => "eNOTIS Study Access", :ext => "access_list"},
    {:name => "eNOTIS Study Accrual", :ext => "accrual"},
    # {:name => "eNOTIS Study Accrual PR", :ext => "periodic_review_accrual"},
    # {:name => "eNOTIS Study Authorized Access", :ext => "authorized_access"},
   # {:name => "eNOTIS Study Authorized Personnel", :ext => "authorized_personnel"},
    {:name => "eNOTIS Study Basics", :ext => "basics"},
   # {:name => "eNOTIS Study Co-Investigators", :ext => "co_investigators"},
    {:name => "eNOTIS Study Funding Sources", :ext => "funding_sources"},
    # DO NOT USE! --> does not map data properly {:name => "eNOTIS Study Combined Priv", :ext => "combined_access"},
   # {:name => "eNOTIS Study Contact List", :ext => "contact_list"},
   # {:name => "eNOTIS Study Coordinators", :ext => "coordinators"},
   # {:name => "eNOTIS Study Principal Investigator", :ext => "principal_investigators"},
    {:name => "eNOTIS Study Status", :ext => "status"},
    {:name => "eNOTIS Study Subject Populations", :ext => "populations"},
    {:name => "eNOTIS Study Description", :ext => "description"},
    {:name => "eNOTIS Study Inclusion Exclusion", :ext => "inc_excl"},
   # {:name => "eNOTIS Study Export", :ext => "study_export" },
    {:name => "eNOTIS Recently Updated Studies", :ext => "recent_studies"}
   ].freeze

  cattr_accessor :eirb_adapter
  
  class << self
    # initializing the eIRB connection
    def connect
      self.eirb_adapter ||= EirbAdapter.new
    end

    def connected?
      !eirb_adapter.nil?
    end
    
    # This method attempts to pull data from the service
    def service_test(irb_number)
      begin
        result = find_basics({:irb_number => irb_number})
        status = (result.first ? (result.first[:irb_number] == irb_number) : false)
        return status, status ? "All good" : "invalid data retrieved"
      rescue => error
        return false, error.message
      end
    end
    
    # Wrapper methods
    STORED_SEARCHES.each do |search|
      send(:define_method, "find_#{search[:ext]}") do |*args|
        if args.empty?
          chunked_search("#{search[:name]}")
        else
          default_search("#{search[:name]}", Webservices.convert(args, NOTIS_TO_EIRB, false).first)
        end
      end
    end
    
    # Search methods
    def default_search(search_name, parameters=nil)
      search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => search_name, :parameters => parameters})
      search(search_settings)
    end
    
    # Breaks search results into managble chunks of data because eIrb chokes if a query is to large
    def chunked_search(search_name, parameters=nil,num_rows=500)
      start_row = 1 # eirb has row 1 as the first row
      results = []
      loop do 
        begin
          partial_results = paginated_search(search_name,start_row,num_rows,parameters)
          break if partial_results.empty? 
          results.concat(partial_results)          
        rescue => e
          LOG.warn("Chunked Search Failed!\n#{e.message}")
          #supress eirb errors and return incomplete dataset
          #  break
        ensure
          start_row += num_rows
        end
      end
      results
    end
    
    def paginated_search(search_name,start_row,num_rows,parameters=nil)
      search_settings = SEARCH_DEFAULTS.merge({
       :savedSearchName => search_name,
       :parameters => parameters,
       :startRow => start_row,
       :numRows => num_rows
      })
      search(search_settings)
    end
    
    def search(settings, convert_headers=true)
      connect unless connected?
      result = eirb_adapter.perform_search(settings) if connected?
      (convert_headers) ? Webservices.convert(result, EIRB_TO_NOTIS) : result
    end

    # Used to create the eIRB half of the translations map
    # Grabs the returned row headers for each query
    def return_query_headers
      headers = {}
      STORED_SEARCHES.each do |s|
        begin
          results = search(SEARCH_DEFAULTS.merge({:savedSearchName => s[:name], :numRows => 1}), false)
          headers[s[:name]] = results.first.keys # Results should be an array with one item in it
        rescue
          headers[s[:name]] = "FAILED"
        end
      end
      headers
    end
  
    # TODO: move to rake task and move parts out of here
    # Creates a format for using in the eirb_translations file
    # Reads the existing one to use it as a base and adds any
    # keys that are missing with a blank value placeholder
    def pretty_print_translation_template
      tt = "#Exported from eirb queries on #{Time.now}\n"
      tt << "EIRB_TO_NOTIS = {\n"
      headers = return_query_headers
      headers.each do |k,v|
        spaces = max_str(v)
        tt << "# #{k} \n"
        [*v].each do |val|
          if existing = EIRB_TO_NOTIS[val]
            tt << pad_print_hash(val,existing,spaces)
          else
            tt << pad_print_hash(val,:NEW_VALUE,spaces)
          end
        end
      end
      tt << "}\n"
      tt
    end

    def max_str(arr)
      max = 0
      arr.each{|a| max = a.length if a.length > max }
      max
    end

    def pad_print_hash(key,value,padding)
      return nil if padding < key.to_s.length
      padding += 3 #for the hash rocket
      t = "\"#{key}\" =>"
      (padding - key.to_s.length).times do
        t << " "
      end
      if value.is_a?(String)
        t << "\"#{value}\",\n"
      else
        t << ":#{value},\n"
      end
    end
    
  end
end

