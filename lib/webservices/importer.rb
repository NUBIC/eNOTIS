# The importer is a simple linear importer designed
# to manage pulling in data from external data sources 
# and updating the eNOTIS application models

module Webservices
  module ImporterSupport

    # The importer process sets imported time
    # this is a simple wrapper to give us a
    # boolean answer
    def imported_since?(time)
      if self.imported_at 
        self.imported_at > time
      else
        false
      end
    end
 
    # Some method to handle the storing 
    # of the data we are importing to the study
    # Just used to store the most recent update
    # to help with diagnostic and data trouble shooting
    # purposes
    def import_errors=(val)
      init_import_cache
      self.import_cache[:errors].merge!(val)
    end

    def import_errors
      init_import_cache
      self.import_cache[:errors]
    end

    def import_results=(val)
      init_import_cache
      self.import_cache[:results].merge!(val)
    end
  
    def import_results
      init_import_cache
      self.import_cache[:results]
    end

    def init_import_cache
      self.import_cache ||= clear_import_cache
    end

    # This is the default structure of the import cache
    def clear_import_cache
      self.import_cache = {:errors => {}, :results => {}}
    end
  end

  class Importer

    class << self

      # Somehow represent:
      # Part of some StudyInfo => eIRB
      # Part of some RoleInfo => EDW
      # 

      # Participants for some studies => NOTIS via EDW
      # Participants for some studies => ANES via EDW
      # Studies with participants elsewhere should 
      # be locked to prevent editing in eNOTIS

      def import_external_study_data(study)
        #import the study data 
        import_base_study_data(study)
       # import_roles_data(study)
       # import_subject_data(study)
       # unless study.import_errors?
          study.imported_at = Time.now
       # end
        study.save
      end      
      
      def import_base_study_data(study)
        import_set = query_study_source(study.irb_number)
        #clean_set = sanitize_study_data(import_set)
        #study.recent_import_data(:study_raw => import_set)
        #study.recent_import_data(:study_clean => clean_set)
        #Study.bulk_update(study, clean_set)
      end

      def import_roles_data(study)
        import_set = query_study_source(study.irb_number)
      end 
      
      def query_study_source(irb_number)
        query_list = [
          :find_basics,
          :find_description,
          :find_inc_excl,
          :find_funding_sources
        ]
        do_import_queries(Eirb, irb_number, query_list)
      end

      def query_roles_source(irb_number)
        query_list = [
          :find_principal_investigators,
          :find_co_investigators,
          :find_authorized_personnel
        ]
        do_import_queries(Edw, irb_number, query_list)
      end

      def query_subjects_source(irb_number)
        query_list = [
         :subject_import_from_NOTIS,
         :subject_import_from_ANES
        ]
        do_import_queries(Edw, irb_number, query_list)
      end

      protected 

      def do_import_queries(source_system, irb_number, query_list)
        dset = {}
        query_list.each do |query|
          dset[query] = source_system.send(query, {:irb_number => irb_number})
        end
        dset
      end

    end
  end
end
