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

    def import_errors?
      self.import_errors
    end

    def import_results=(val)
      init_import_cache
      self.import_cache.merge!(val)
    end

    def import_results
      init_import_cache
      self.import_cache
    end

    def init_import_cache
      self.import_cache ||= {}
    end

    # This is the default structure of the import cache
    def clear_import_cache
      self.import_cache = {}
    end
  end

  class Importer

    class << self

      # Somehow represent:
      # Part of some StudyInfo => eIRB
      # -Update in study class handles setting the study data 
      # to what is passed in
      # Part of some RoleInfo => EDW
      # -Roles might need a source field real soon
      # this would let us have local roles which were 
      # updated and managed by eNOTIS

      # Participants for some studies => NOTIS via EDW
      # Participants for some studies => ANES via EDW
      # Studies with participants elsewhere should 
      # be locked to prevent editing in eNOTIS

      def import_external_study_data(study)
        study_set = {:raw =>{:errors => []}, :clean => {:errors => []}} # setting our temporary data hold

        # Querying the sources
        study_set[:raw][:study] = query_study_source(study.irb_number)
        study_set[:raw][:roles] = query_roles_source(study.irb_number)
        #study_set[:subjects] = query_subjects_source(study.irb_number)

        # Cleaning the results 
        study_set[:clean] = sanitize(study_set[:raw])

        # Doing teh imports
        unless study_set[:clean][:study].nil? or study_set[:clean][:study].empty?
          Study.import_update(study, study_set[:clean][:study])
        end
        unless study_set[:clean][:study].nil? or study_set[:clean][:roles].empty?
          Role.import_update(study, study_set[:clean][:roles])
        end
        #Involvement.import_update(study, study_set[:clean][:subjects]

        # Setting some import process data
        study.import_results = study_set
        study.import_errors = !(study_set[:raw][:errors].empty? and study_set[:clean][:errors].empty?)
        study.imported_at = Time.now
        study.save
      end      

      def sanitize(study_set)
        clean_set = {:study => [], :roles => [], :subjects => [], :errors => []}
        begin
          clean_set[:study] = sanitize_study(study_set[:study])
        rescue Exception => err
          clean_set[:errors] << err.to_s
        end
        begin
          clean_set[:roles] = sanitize_roles(study_set[:roles])
        rescue Exception => err 
          clean_set[:errors] << err.to_s
        end
        # TODO: Sanitize involvements
        return clean_set
      end

      def sanitize_study(study_set)
        study = {}
        # pulling out the data from the hash structure where the hash 
        # results are under the name of the query
        unless study_set[:find_basics].empty?  
          bh = study_set[:find_basics].first
          study[:approved_date] = Chronic.parse(bh[:approved_date])
          study[:expired_date] = Chronic.parse(bh[:expired_date])
          study[:expiration_date] = Chronic.parse(bh[:expiration_date])
          study[:created_date] = Chronic.parse(bh[:created_date])
          study[:modified_date] = Chronic.parse(bh[:modified_date])
          study[:closed_or_completed_date] = Chronic.parse(bh[:closed_or_completed_date])

          study[:periodic_review_open] = bh[:periodic_review_open]
          study[:accrual_goal] = bh[:accrual_goal]
          study[:name] = bh[:name]
          study[:is_a_clinical_investigation] = bh[:is_a_clinical_investigation]
          study[:fda_offlabel_agent] = bh[:fda_offlabel_agent]
          study[:fda_unapproved_agent] = bh[:fda_unapproved_agent]
          study[:irb_status] = bh[:irb_status]
          study[:subject_expected_completion_count] = bh[:subject_expected_completion_count]
          study[:closed_or_completed_date] = Chronic.parse(bh[:closed_or_completed_date])
          study[:clinical_trial_submitter] = bh[:clinical_trial_submitter] 
          study[:research_type] = bh[:research_type]
          study[:review_type_requested] = bh[:review_type_requested]
          study[:title] = bh[:title]
          study[:total_subjects_at_all_ctrs] = bh[:total_subjects_at_all_ctrs]
        end

        if !study_set[:find_description].empty? and study_set[:find_description].first[:description]
          study[:description] = study_set[:find_description].first[:description]
        end

        if !study_set[:find_inc_excl].empty?
          incl = study_set[:find_inc_excl].first
          study[:exclusion_criteria] = incl[:exclusion_criteria]
          study[:inclusion_criteria] = incl[:inclusion_criteria]
        end

        study_set[:find_funding_sources].each do |fs|
          study[:funding_sources] ||= []
          study[:funding_sources] << {:name => fs[:funding_source_name], :code => fs[:funding_source_id], :category => fs[:funding_source_category_name]}
        end

        return study
      end

      def sanitize_roles(roles_set)
        roles = []
        if roles_set[:find_principal_investigators]
          roles_set[:find_principal_investigators].each do |pi|
            # note: we set the roles here, so all that's really needed is the netid
            roles << {:netid => pi[:netid], :project_role => "Principal Investigator", :consent_role => "Obtaining"}
          end
        end
        if roles_set[:find_co_investigators]
          roles_set[:find_co_investigators].each do |ci|
            # note: we set the roles here, so all that's really needed is the netid
            roles << {:netid => ci[:netid], :project_role => "Co-Investigator", :consent_role => "Obtaining"}
          end
        end
        if roles_set[:find_authorized_personnel]
          roles_set[:find_authorized_personnel].each do |ap|
            # We need more than just netid here
            roles << {:netid => ap[:netid], :project_role => ap[:project_role], :consent_role => ap[:consent_role]}
          end
        end
        roles.reject! do |r|
          r[:netid].blank? or r[:project_role].blank? or r[:consent_role].blank?
        end
        roles
      end

      # These are the setup methods for a target
      # data model. They contain the list of queries to run
      # the target data source, and the only require the 
      # irb_number as the key to request the data
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

      # This is where we actually make the queries,
      # record their results, and catch any errors.
      # Returns: a hash containing a key corresponding to the
      # name of the query run, and then a value corresponding
      # to what was returned from the webservice query to 
      # the designated system. If there are any errors
      # those get stored in an :errors key
      #
      # For example: 
      # { :find_basics => <return hash from query>,
      #   :errors => [{error => <error name>, :at => <time>, :request => <requst details>}],
      #   :find_inc_excl => <return hash from query>,
      #   :find_funding_sources => <return hash from query>
      #   }
      def do_import_queries(source_system, irb_number, query_list)
        dset = {}
        query_list.each do |query|
          begin
            dset[query] = source_system.send(query, {:irb_number => irb_number})
          rescue Exception => err
            dset[:errors] ||=[]
            dset[:errors] << {
              :error => err.to_s, 
              :at => Time.now,
              :request => {
              :source => source_system,
              :irb_number => irb_number,
              :query => query
            }
            }
          end
        end
        dset
      end

    end
  end
end
