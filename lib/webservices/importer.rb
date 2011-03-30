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
      self.import_errors == true
    end

    def flatten_import_cache
      val = self.import_cache
      if val.respond_to?(:keys)
        results = ""
        val.keys.each do |k|
          results << "#{k} => #{val[k].inspect}\n"
        end
      else
        results = val.to_s
      end
      write_attribute :import_cache, results
    end

    # This is the default structure of the import cache
    def clear_import_cache
      self.import_cache = {}
      self.import_errors = false
    end
  end

  class Importer

    class << self
  
      # Importing...
      # Part of some StudyInfo => eIRB
      # Part of some RoleInfo => EDW
      # -NOTE: Roles might need a source field real soon this would let us have local roles which were updated and managed by eNOTIS
      # Participants for some studies => NOTIS via EDW
      # Participants for some studies => ANES via EDW
      
      def import_external_study_data(study)
        # NOTE: There are some assumptions here about the structure of the hash we
        # use to temporarily store our import data. The clean and raw data sets should all have
        # the following keys, :study, :roles, :subjects, :errors

        # Querying the sources 
        study_raw = query_sources(study) 
        # Cleaning the results 
        study_clean = sanitize(study_raw)
        
        # Actally loading data into our data models
        Study.import_update(study, study_clean[:study]) unless study_clean[:study].blank?
        Role.import_update(study, study_clean[:roles]) unless study_clean[:roles].blank?
        if study.is_managed?
          Involvement.import_update(study, study_clean[:involvements]) 
        end

        # Setting some import process data
        study.clear_import_cache
        if !study_raw[:errors].blank? or !study_clean[:errors].blank?
          study.import_cache = {:ws_errors =>study_raw[:errors], :sanitize_errors => study_clean[:errors]}
          study.import_errors = true
        end
        study.imported_at = Time.now
        study.save
      end      

      def sanitize(study_set)
        clean_set = {:study => [], :roles => [], :involvements => [], :errors => []}
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
        begin
          clean_set[:involvements] = sanitize_involvements(study_set[:involvements])
        rescue Exception => err
          clean_set[:errors] << err.to_s
        end
        return clean_set
      end

      def sanitize_study(study_set)
        study = {}
        # pulling out the data from the hash structure where the hash 
        # results are under the name of the query
        unless study_set[:find_basics].blank?  
          bh = study_set[:find_basics].first
          study[:approved_date] = Chronic.parse(bh[:approved_date])
          study[:expired_date] = Chronic.parse(bh[:expired_date])
          study[:expiration_date] = Chronic.parse(bh[:expiration_date])
          study[:created_date] = Chronic.parse(bh[:created_date])
          study[:modified_date] = Chronic.parse(bh[:modified_date])
          study[:periodic_review_open] = bh[:periodic_review_open]
          study[:accrual_goal] = bh[:accrual_goal]
          study[:name] = bh[:name]
          study[:is_a_clinical_investigation] = bh[:is_a_clinical_investigation]
          study[:fda_offlabel_agent] = bh[:fda_offlabel_agent]
          study[:fda_unapproved_agent] = bh[:fda_unapproved_agent]
          study[:irb_status] = bh[:irb_status]
          study[:subject_expected_completion_count] = bh[:subject_expected_completion_count]
          # Adjusted to fix a bug in eIRB 
          closed_or_completed_date = Chronic.parse(bh[:closed_or_completed_date])
          study[:closed_or_completed_date] = fix_closed_completed_bug(closed_or_completed_date, study[:irb_status], study[:expired_date])

          study[:clinical_trial_submitter] = bh[:clinical_trial_submitter] 
          study[:research_type] = bh[:research_type]
          study[:review_type_requested] = bh[:review_type_requested]
          study[:title] = bh[:title]
          study[:total_subjects_at_all_ctrs] = bh[:total_subjects_at_all_ctrs]
        end

        if !study_set[:find_description].blank? and study_set[:find_description].first[:description]
          study[:description] = study_set[:find_description].first[:description]
        end

        if !study_set[:find_inc_excl].blank?
          incl = study_set[:find_inc_excl].first
          study[:exclusion_criteria] = incl[:exclusion_criteria]
          study[:inclusion_criteria] = incl[:inclusion_criteria]
        end

        study_set[:find_funding_sources].each do |fs|
          study[:funding_sources] ||= []
          unless fs[:funding_source_name].blank? or fs[:funding_source_id].blank? or fs[:funding_source_category_name].blank?
            study[:funding_sources] << {:name => fs[:funding_source_name], :code => fs[:funding_source_id], :category => fs[:funding_source_category_name]}
          end
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
        return roles
      end
      
      def sanitize_involvements(inv_set)
        # the involvements_set format is :query_name => <data_hash>
        # We will use the query name to identify the source system (eg NOTIS or ANES)
        # and then procede to sanitize the data based on that. We have to use
        # different sanitation for different sources.
        if inv_set.has_key?(:find_NOTIS_study_subjects)
          return sanitize_NOTIS_involvements(inv_set[:find_NOTIS_study_subjects])
        elsif inv_set.has_key?(:find_ANES_study_subjects)
          return sanitize_ANES_involvements(inv_set[:find_ANES_study_subjects])
        elsif inv_set.has_key?(:find_REGISTAR_study_subjects)
          return sanitize_REGISTAR_involvements(inv_set[:find_REGISTAR_study_subjects])
        else
          return []
        end
      end

      def sanitize_NOTIS_involvements(notis_set)
        # Example data set from NOTIS
        # :find_NOTIS_study_subjects => [{:protocol_id=>"1746", 
        # :mrd_pt_id=>"244444444", :ethnicity=>"Non-Hispanic",
        # :sex=>"F", :completed_date=>"1/10/2011", :mrn=>"123321",
        # :mrn_type=>"NMFF G#", :last_name=>"Smith", :birth_date=>"1/11/1955",
        # :address_1=>"50 W. Street", :zip=>"10642", :death_date=>"", :withdrawn_date=>"",
        # :patient_created=>"2010-1-10T13:55:23", :irb_number=>"STU00019833", 
        # :case_number=>"1106", :address_2=>"Apt 106", :patient_id=>"5587555", :race=>"White",
        # :affiliate_id=>"1918", :first_name=>"Traci", :race_ethnicity_created=>"2010-1-10T13:55:23",
        # :phone=>"3215551233", :state=>"IL", :city=>"Chicago", :consented_date=>"1/12/2010"}]
        invs_set = []
        notis_set.each do |subject_hash| 
          invs = {}
          subject_hash.reject!{|k,v| v.blank?}
          invs[:subject] = {

            :birth_date          => subject_hash[:birth_date],
            :death_date          => subject_hash[:death_date],
            :first_name          => subject_hash[:first_name],
            :last_name           => subject_hash[:last_name],
            :nmff_mrn            => /NMFF/ =~ subject_hash[:mrn_type] ? subject_hash[:mrn] : nil,
            :nmh_mrn             => /NMH/ =~ subject_hash[:mrn_type] ? subject_hash[:mrn] : nil,
            :external_patient_id => subject_hash[:patient_id],
            :import_source => 'NOTIS'
          }

          invs[:involvement] = {
            :address_line1       => subject_hash[:address_1],
            :address_line2       => subject_hash[:address_2],
            :city                => subject_hash[:city],
            :state               => subject_hash[:state],
            :zip                 => subject_hash[:zip],
            :home_phone          => subject_hash[:phone],
            :gender      => NOTIS_gender(subject_hash[:sex]),
            :case_number => subject_hash[:case_number],
            :ethnicity   => NOTIS_ethnicity(subject_hash[:ethnicity])
            }.merge(NOTIS_race(subject_hash[:race]))

          invs[:involvement][:involvement_events] = {
            :consented_date => subject_hash[:consented_date],
            :withdrawn_date => subject_hash[:withdrawn_date],
            :completed_date => subject_hash[:completed_date]
          }
          #removing blank/nil events from above assignments
           invs[:involvement][:involvement_events].reject!{|k,v| v.blank?}
           invs[:involvement].reject!{|k,v| v.blank?}
           invs[:subject].reject!{|k,v| v.blank?}
           invs_set << invs
        end
        return invs_set
      end

      def sanitize_ANES_involvements(anes_set)
        # Example data set from ANES
        # :find_ANES_study_subjects => [{:withdrawn_on=>"", :ethnicity=>"Not Hispanic or Latino",
        #  :completed_on=>"2011-02-10", :mrn=>"091823888", :last_name=>"MIAOS", :birth_date=>"2/26/1982",
        #  :gender=>"Female", :case_number=>"105", :race=>"White", :patient_id=>"3672", 
        #  :first_name=>"LORI", :consented_on=>"2011-02-10"}]
        invs_set = []
        anes_set.each do |subject_hash| 
          invs = {}
          subject_hash.reject!{|k,v| v.blank?}
          invs[:subject] = {
            :birth_date          => subject_hash[:birth_date],
            :first_name          => subject_hash[:first_name],
            :last_name           => subject_hash[:last_name],
            :nmh_mrn            => subject_hash[:mrn], # only nmh nmrns from this source TODO:get codede type
            :external_patient_id => subject_hash[:patient_id],
            :import_source => 'ANES'
          }

          invs[:involvement] = {
            :gender      => subject_hash[:gender] || "Unknown or Not Reported",
            :case_number => subject_hash[:case_number],
            :ethnicity   => subject_hash[:ethnicity] || "Unknown or Not Reported"
            }.merge(NOTIS_race(subject_hash[:race])) #sharing the notis race setting method. it was updated to return { :race_is_unknown_or_not_reported => true } for nil

          invs[:involvement][:involvement_events] = {
            :consented_date => subject_hash[:consented_on],
            :withdrawn_date => subject_hash[:withdrawn_on],
            :completed_date => subject_hash[:completed_on]
          }
          #removing blank/nil events from above assignments
           invs[:involvement][:involvement_events].reject!{|k,v| v.blank?}
           invs[:involvement].reject!{|k,v| v.blank?}
           invs[:subject].reject!{|k,v| v.blank?}
           invs_set << invs
        end
        return invs_set
      end

      def sanitize_REGISTAR_involvements(reg_set)
        # Example data set from REGISTAR
        # :find_REGISTAR_study_subjects => [{:consented_on=>"2011-03-03T00:00:00",
        # :state=>"illinois", :ethnicity=>"hispanic or latino",
        # :birth_date=>"1984-11-22T00:00:00", :email=>"s-velaz123@northwestern.edu",
        # :gender=>"female", :irb_number=>"STU00017234", :race=>"white", :primary_phone_number=>"773-494-1824",
        # :last_name=>"Velaz", :address_line1=>"3018 W. Street Ave.", :first_name=>"Salty", :city=>"Chicago"}]
        #
        invs_set = []
        reg_set.each do |subject_hash| 
          invs = {}
          subject_hash.reject!{|k,v| v.blank?}
          invs[:subject] = {
            :birth_date          => subject_hash[:birth_date],
            :first_name          => subject_hash[:first_name],
            :last_name           => subject_hash[:last_name],
            :middle_name         => subject_hash[:middle_name],
            #:nmff_mrn            => subject_hash[:mrn], # TODO: square this out with registar source. Get an MRN type in there!
            :external_patient_id => subject_hash[:patient_id],
            :import_source => 'REGISTAR'
          }

          invs[:involvement] = {
            :gender      => subject_hash[:gender] || "Unknown or Not Reported",
            #:case_number => subject_hash[:case_number], # No case number for registar yet
            :ethnicity   => subject_hash[:ethnicity] || "Unknown or Not Reported"
            }.merge(NOTIS_race(subject_hash[:race])) #sharing the notis race setting method. it was updated to return { :race_is_unknown_or_not_reported => true } for nil

          invs[:involvement][:involvement_events] = {
            :consented_date => subject_hash[:consented_on],
            :withdrawn_date => subject_hash[:withdrawn_on],
            :completed_date => subject_hash[:completed_on]
          }
          #removing blank/nil events from above assignments
           invs[:involvement][:involvement_events].reject!{|k,v| v.blank?}
           invs[:involvement].reject!{|k,v| v.blank?}
           invs[:subject].reject!{|k,v| v.blank?}
           invs_set << invs
        end
        return invs_set
      end

      # Queries the sources and sets up our temporary data hash 
      def query_sources(study)
        study_raw = {:errors => []}
        study_raw[:study] = query_study_source(study.irb_number)
        study_raw[:roles] = query_roles_source(study.irb_number)
        study_raw[:involvements] = {}
        if study.is_managed?
          study_raw[:involvements] = query_involvements_source(study.irb_number, study.managing_system)
        end

        # collecting our errors
        study_raw[:errors].concat(study_raw[:study][:errors])
        study_raw[:errors].concat(study_raw[:roles][:errors])
        study_raw[:errors].concat(study_raw[:involvements][:errors]) if study.is_managed?
        return study_raw
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

      def query_involvements_source(irb_number, source)
        query = "find_#{source}_study_subjects".to_sym
        do_import_queries(Edw,irb_number,[query])
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
        dset = {:errors => []}
        query_list.each do |query|
          begin
            dset[query] = source_system.send(query, {:irb_number => irb_number})
          rescue Exception => err
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

      # Aux methods for sanitization
      
      def fix_closed_completed_bug(clsd_comp_date, irb_status, exp_date)
        # closed statuses
        cs = ["Closed/Terminated", "Expired", "Completed"]
        if cs.include?(irb_status) and exp_date < Time.now
          clsd_comp_date
        else
          nil
        end
      end

      def NOTIS_gender(gender)
        case gender
        when "F"
          "Female"
        when "M"
          "Male"
        else
          "Unknown or Not Reported"
        end
      end

      def NOTIS_ethnicity(ethnicity)
        case ethnicity
        when  "Hispanic or Latino"
          "Hispanic or Latino"
        when "Non-Hispanic"
          "Not Hispanic or Latino"
        else
          "Unknown or Not Reported"
        end
      end

      def NOTIS_race(race)
        case race
        when "White"
          { :race_is_white => true }
        when "Black"
          { :race_is_black_or_african_american => true }
        when "Asian"
          { :race_is_asian => true }
        when "Native Hawaiian or Other Pacific Islander"
          { :race_is_native_hawaiian_or_other_pacific_islander => true }
        when "American Indian or Alaska Native"
          { :race_is_american_indian_or_alaska_native => true }
        when "Unknown"
          { :race_is_unknown_or_not_reported => true }
        when "Placeholder"
          { :race_is_unknown_or_not_reported => true }
        else
          { :race_is_unknown_or_not_reported => true }
        end
      end

    end ## end class << self
  end
end
