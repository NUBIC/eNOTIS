require 'eirb_adapter'
require 'eirb_translations'

class EirbServices

  # basic settings for single row queries
  SEARCH_DEFAULTS = {:startRow => 1, 
                   :numRows => -1,
                   :expandMultiValueCells => false}.freeze
  
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
  def self.find_status(study_id)
    result = default_search("eNOTIS Study Status",{"ID" => study_id})
    convert_for_notis(result)
  end

  def self.find_by_irb_number(conditions)
    result = default_search("eNOTIS Study Basics",{"ID" => conditions[:irb_number]})
    convert_for_notis(result)
  end 

  def self.find_study_research_type(study_id)
    result = default_search("eNOTIS Study Research Type",{"ID" => study_id})
    convert_for_notis(result)
  end

  def self.find_by_netid(user_netid=nil)
    result = default_search("eNOTIS Person Details",{"NetID" => user_netid})
    convert_for_notis(result)
  end
  
  def self.find_study_access(study_id=nil)
    result = default_search("eNOTIS Study Access", (study_id.nil? ? nil : {"ID" => study_id}))
    #convert_for_notis(result)
  end

  # ======== Search helper methods =========
  def self.default_search(search_name, parameters)
    search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => search_name,
                                            :parameters => parameters})
    connect unless connected?
    eirb_adapter.perform_search(search_settings) if connected?
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
          result[converter[key.to_s].to_sym] = value unless !converter.has_key?key.to_s
        end 
        results << result
      end
      return results
  end
end
