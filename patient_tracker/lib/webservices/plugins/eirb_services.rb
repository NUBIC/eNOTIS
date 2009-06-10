require 'eirb_adapter'

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
    eirb_adapter = EirbAdapter.new(config)
  end

  def self.connected?
    !eirb_adapter.nil?
  end

  # ======== eIRB webservice wrapper methods ========
  def self.find_status(study_id)
    default_search("eNOTIS Study Status",{"ID" => study_id})
  end

  def self.find_by_irb_number(study_id)
    default_search("eNOTIS Study Basics",{"ID" => study_id})      
  end 

  def self.find_study_research_type(study_id)
    default_search("eNOTIS Study Research Type",{"ID" => study_id})
  end

  def self.find_by_netid(user_netid=nil)
    default_search("eNOTIS Person Details",{"NetID" => user_netid})
  end
  
  def self.find_study_access(study_id=nil)
    default_search("eNOTIS Study Access", (study_id.nil? ? nil : {"ID" => study_id}))
  end

  # ======== Search helper methods =========
  def self.default_search(search_name, parameters)
    search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => search_name,
                                            :parameters => parameters})
    connect unless connected?
    eirb_adapter.perform_search(search_settings) if connected?
  end
end
