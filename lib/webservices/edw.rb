class Edw
  cattr_accessor :edw_adapter
  
  class << self
    # initializing the EDW connection
    def connect
      self.edw_adapter ||= EdwAdapter.new
    end

    def service_test
      # get test mrnA
      config = WebserviceConfig.new("/etc/nubic/edw-#{RAILS_ENV.downcase}.yml")
      begin
        result = find_by_mrn({:mrn => config[:test_mrn]})
        status = (result.first ? result.first[:mrn] == config[:test_mrn] : false)
        return status, status ? "All good" : "Invalid data returned"
      rescue => error
        return false,error.message
      end
    end

    # Subject methods
    def find_by_mrn(conditions)
      connect
      result = edw_adapter.perform_search(Webservices.convert([conditions], NOTIS_TO_EDW).first)
      Webservices.convert(result, EDW_TO_NOTIS)
    end
    def find_by_name_and_dob(conditions)
      connect
      result = edw_adapter.perform_search(Webservices.convert([conditions], NOTIS_TO_EDW).first)
      Webservices.convert(result, EDW_TO_NOTIS)
    end
  end
end
