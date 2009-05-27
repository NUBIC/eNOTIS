
  module PatientServices  
    def find_by_mrn
      return 'edw stuff'
    end
  end
  module ProtocolServices

    def find_by_study_id
    end
  end

module EdwService

    def self.find_by_mrn(mrn)
      s = {}
      s["first_name"] = "David"
      s["last_name"] = "w"
      s["mrn"] = mrn
      return s
    end

    def self.find_by_last_name(test)
      return test

    end



end
