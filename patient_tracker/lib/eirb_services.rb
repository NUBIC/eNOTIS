

module EirbServices

  SEARCH_DEFAULTS = {:startRow => 1, 
                   :numRows => -1,
                   :expandMultiValueCells => false}.freeze
  
  class EirbService

    def initialize
      config = ServiceConfig.new(RAILS_ENV)

      @adapter = EirbAdapter(config)
    end

     # Performs a query to get the study status using the study ID 
     def find_status_by_id(study_id)
       # merging in the defaults, overwritting ones we need to
       search_settings = SEARCH_DEFAULTS.merge({:savedSearchName => "idStatus",
                                               :parameters => {:id => study_id}})
       @adapter.perform_search(search_settings)  
     end
  end
end
