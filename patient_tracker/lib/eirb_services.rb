require 'eirb_adapter'

module EirbServices

  SEARCH_DEFAULTS = {:startRow => 1, 
                   :numRows => -1,
                   :expandMultiValueCells => false}.freeze
  
  class EirbService 

    # initialzes the service class 
    def initialize
      yml = File.open(File.join(RAILS_ROOT,"config/eirb_services.yml"))
      config = ServiceConfig.new(RAILS_ENV, YAML.parse(yml))
      @adapter = EirbAdapter.new(config)
    end

    # Performs a query to get the study status using the study ID 
    def find_status_by_id(study_id)
      # merging in the defaults, overwritting ones we need to
      search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => "idStatus",
                                              :parameters => {:id => study_id}})
      @adapter.perform_search(search_settings)  
    end

    def find_by_study_id(study_id)

    end
  end
end
