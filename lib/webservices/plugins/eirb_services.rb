require 'eirb_adapter'
require 'eirb_translations'
require 'service_logger'

class EirbServices

  # basic settings for single row queries
  SEARCH_DEFAULTS = {:startRow => 1, 
                   :numRows => -1,
                   :expandMultiValueCells => true}.freeze
  
  DATA_REMAP = {}

  STORED_SEARCHES = [{:name => "eNOTIS Study Accrual PR", :ext => "accrual"},
  {:name => "eNOTIS Study Authorized Personnel", :ext => "authorized_personnel"},
  {:name => "eNOTIS Study Basics", :ext => "basics"},
  {:name => "eNOTIS Study Co-Investigators", :ext => "co_investigators"},
  {:name => "eNOTIS Study Coordinators", :ext => "coordinators"},
  {:name => "eNOTIS Study Key Research Personnel", :ext => "key_personnell"},
  {:name => "eNOTIS Study Principal Investigator", :ext => "principal_investigator"},
  {:name => "eNOTIS Study Status", :ext => "status"},
  {:name => "eNOTIS Study Access", :ext => "access_list"},
  {:name => "eNOTIS Study Subject Populations", :ext => "populations"}].freeze

  cattr_accessor :eirb_adapter

  # initializing the eIrb connection
  def self.connect
    # We are using ERB here because we've moved the configs to use bcdatabase, which has erb template code in it
    yml = ERB.new(File.read(File.join(RAILS_ROOT,"config/eirb_services.yml"))).result
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    self.eirb_adapter = EirbAdapter.new(config)
  end

  def self.connected?
    !eirb_adapter.nil?
  end

  # ======== eIRB webservice wrapper methods ========
    STORED_SEARCHES.each do |search|

      meth=<<WMETH
      def find_#{search[:ext]}(conditions = nil)
        if conditions
          default_search("#{search[:name]}", convert_for_eirb(conditions))
        else
          chunked_search("#{search[:name]}")
        end
      end
WMETH
      instance_eval(meth)
    end

  # ======== Search helper methods =========
  def self.default_search(search_name, parameters=nil)
    search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => search_name,
                                            :parameters => parameters})
    search(search_settings)
  end
 
  # Breaks search results into managble chunks of data
  # because eIrb chokes if a query is to large
  def self.chunked_search(search_name, parameters=nil,num_rows=500)
    start_row = 1 #eirb has row 1 as the first row
    results = []

    loop do 
      partial_results = paginated_search(search_name,start_row,num_rows,parameters)
      break if partial_results.empty? 
      results.concat(partial_results)
      start_row += num_rows
    end
    results
  end

  def self.paginated_search(search_name,start_row,num_rows,parameters=nil)
    search_settings = SEARCH_DEFAULTS.merge({
     :savedSearchName => search_name,
     :parameters => parameters,
     :startRow => start_row,
     :numRows => num_rows
    })
    
    search(search_settings)
  end

  def self.search(settings, convert_headers=true)
    connect unless connected?
    result = eirb_adapter.perform_search(settings) if connected?
    (convert_headers) ? convert_for_notis(result) : result
  end

  # Used to create the eIRB half of the translations map
  # Grabs the returned row headers for each query
  def self.return_query_headers
    headers = {}
    STORED_SEARCHES.each do |s|
      begin
        results = search(SEARCH_DEFAULTS.merge({:savedSearchName => s[:name],:numRows => 1}),false)
        headers[s[:name]] = results.first.keys # Results should be an array with one item in it
      rescue
        headers[s[:name]] = "FAILED"
      end
    end
    headers
  end

  # Creates a format for using in the eirb_translations file
  # Reads the existing one to use it as a base and adds any
  # keys that are missing with a blank value placeholder
  def self.pretty_print_translation_template
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
          tt << pad_print_hash(val,"NEW_VALUE",spaces)
        end
      end
    end
    tt << "}\n"
    tt
  end

  def self.max_str(arr)
    max = 0
    arr.each{|a| max = a.length if a.length > max }
    max
  end

  def self.pad_print_hash(key,value,padding)
    return nil if padding < key.to_s.length
    padding += 3 #for the hash rocket
    t = "\"#{key}\" =>"
    (padding - key.to_s.length).times do
      t << " "
    end
    t << "\"#{value}\"\n"
  end

  # This method attempts to pull data from the service
  def self.service_test()
    yml = ERB.new(File.read(File.join(RAILS_ROOT,"config/eirb_services.yml"))).result
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    begin
      result = find_by_irb_number({:irb_number=>config.test_irb_number})
      status = (result.first ? (result.first[:irb_number] == config.test_irb_number) : false)
      return status, status ?  "All good":"invalid data retrieved"
    rescue => error
      return false,error.message
    end
  end

  # ======== Attribute converstion Helper Methods =========

  def self.convert_for_notis(values) 
    convert(values,EIRB_TO_NOTIS)
  end

  def self.convert_for_eirb(values)
    convert([values],NOTIS_TO_EIRB).first
  end

  private
  def self.convert(values,converter)
      results=[]
      return values unless !values.nil? 
      values.each do |val|
        result ={} 
        val.each do |key,value|
          result[converter[key]] = value unless !converter.has_key?key
        end 
        results << result
      end
      return results
  end
end
