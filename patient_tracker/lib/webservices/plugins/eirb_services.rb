require 'eirb_adapter'
require 'eirb_translations'
require 'service_logger'

class EirbServices

  # basic settings for single row queries
  SEARCH_DEFAULTS = {:startRow => 1, 
                   :numRows => -1,
                   :expandMultiValueCells => true}.freeze
  
  DATA_REMAP = {}

  cattr_accessor :eirb_adapter

  # initializing the eIrb connection
  def self.connect
    yml = File.open(File.join(RAILS_ROOT,"config/eirb_services.yml"))
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    self.eirb_adapter = EirbAdapter.new(config)
  end

  def self.connected?
    !eirb_adapter.nil?
  end

  # ======== eIRB webservice wrapper methods ========
  def self.find_status(conditions)
    default_search("eNOTIS Study Status",convert_for_eirb(conditions))
  end

  def self.find_by_irb_number(conditions)
    WSLOGGER.debug(conditions.inspect)
    WSLOGGER.debug(convert_for_eirb(conditions).inspect)
    default_search("eNOTIS Study Basics",convert_for_eirb(conditions))
  end 

  def self.find_study_research_type(conditions)
    default_search("eNOTIS Study Research Type",convert_for_eirb(conditions))
  end

  def self.find_by_netid(conditions)
    default_search("eNOTIS Person Details",convert_for_eirb(conditions))
  end
  
  def self.find_study_access(study_id=nil)
    chunked_search("eNOTIS Study Access", (study_id.nil? ? nil : {"ID" => study_id}))
  end

  def self.find_all_users
    chunked_search("eNOTIS Person List")
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
      start_row += partial_results.size
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

  def self.search(settings)
    connect unless connected?
    result = eirb_adapter.perform_search(settings) if connected?
    convert_for_notis(result)   
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
