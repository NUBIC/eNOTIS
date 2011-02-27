require 'webservices'

class Edw
  
  # SEARCH_DEFAULTS = { 
  #                    }.freeze

  STORED_SEARCHES = [
    {:name => "eNOTISeIRBAuthorizedPersonnel", :ext => "authorized_personnel"},
    {:name => "eNOTISeIRBPrincipalInvestigators", :ext => "principal_investigators"},
    {:name => "eNOTISeIRBCoInvestigators", :ext => "co_investigators"},
    {:name => "eNOTISNOTISstudysubjects", :ext => "NOTIS_study_subjects"},
    {:name => "eNOTISNOTISstudylist", :ext => "NOTIS_study_list"},
    {:name => "eNOTISANESstudysubjects", :ext => "ANES_study_subjects"},
    {:name => "eNOTISANESstudylist", :ext => "ANES_study_list"},
   ].freeze

  cattr_accessor :edw_adapter
  
  class << self
    # initializing the EDW connection
    def connect
      self.edw_adapter ||= EdwAdapter.new
    end

    def service_test
      # get test mrnA
      config = WebserviceConfig.new("/etc/nubic/edw-#{Rails.env.downcase}.yml")
      begin
        result = find_test({:mrn => config[:test_mrn]})
        status = (result.first ? result.first[:mrn] == config[:test_mrn] : false)
        return status, status ? "All good" : "Invalid data returned"
      rescue => error
        return false,error.message
      end
    end
   
    # Wrapper methods
    STORED_SEARCHES.each do |search|
      send(:define_method, "find_#{search[:ext]}") do |*args|
        if args.empty?
          search("#{search[:name]}")
        else
          search("#{search[:name]}", Webservices.convert(args, NOTIS_TO_EDW, false).first)
        end
      end
    end
    
    def search(search_name, params = {}, convert_headers = true)
      connect
      result = edw_adapter.perform_search(search_name, params)
      (convert_headers) ? Webservices.convert(result, EDW_TO_NOTIS) : result      
    end

  end
end
