require 'eirb_adapter'

module EirbServices

  # basic settings for single row queries
  SEARCH_DEFAULTS = {:startRow => 1, 
                   :numRows => -1,
                   :expandMultiValueCells => false}.freeze
  
  DATA_REMAP = {}

  attr_accessor :eirb_adapter

  # initializing the eIrb connection
  def connect
    yml = File.open(File.join(RAILS_ROOT,"config/eirb_services.yml"))
    config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
    eirb_adapter = EirbAdapter.new(config)
  end

  def connected?
    !eirb_adapter.nil?
  end

  # ======== eIRB webservice wrapper methods ========

  def find_status(study_id)
    default_search("eNOTIS Study Status",{"ID" => study_id})
  end

  def find_study_basics(study_id)
    default_search("eNOTIS Study Basics",{"ID" => study_id})      
  end 

  def find_study_research_type(study_id)
    default_search("eNOTIS Study Research Type",{"ID" => study_id})
  end

  def find_person_details(user_netid=nil)
    default_search("eNOTIS Person Details",{"NetID" => user_netid})
  end
  
  def find_study_access(study_id=nil)
    default_search("eNOTIS Study Access", (study_id.nil? ? nil : {"ID" => study_id}))
  end
  # ======== Search helper methods =========

  def default_search(search_name, parameters)
    search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => search_name,
                                            :parameters => parameters})
    connect unless connected?
    eirb_adapter.perform_search(search_settings) if connected?
  end
end
