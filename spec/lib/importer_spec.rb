require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Webservices::Importer do

  describe "Importing a study," do

    describe "the instance" do
      before(:each) do
        @study = Factory(:study)
      end

      it "should know when it has been updated by import" do
        ts = Time.now
        @study.imported_since?(ts).should be_false
        Webservices::Importer.should_receive(:query_study_source).and_return({:errors => [], :find_basics =>{:name => "The study"}})
        Webservices::Importer.should_receive(:query_roles_source).and_return({:errors => [], :find_principal_investigators => {:netid => "abc154", :project_role => "PI", :consent_role => "None"}})
        Webservices::Importer.import_external_study_data(@study)
        @study.imported_since?(ts).should be_true
      end
    
      it "should call the subect involvement importer if the study is managed" do
        @study.managed_by('NOTIS')
        Webservices::Importer.should_receive(:query_study_source).and_return({:errors => [], :find_basics =>{:name => "The study"}})
        Webservices::Importer.should_receive(:query_roles_source).and_return({:errors => [], :find_principal_investigators => {:netid => "abc154", :project_role => "PI", :consent_role => "None"}})
        Webservices::Importer.should_receive(:query_involvements_source).and_return({:errors => [], :find_NOTIS_study_subjects => []})
        Webservices::Importer.import_external_study_data(@study)
      end

      it "should clear the import cache and reset error flag" do
        @study.import_cache = {:foo => "HELP"}
        @study.import_cache[:foo].should == "HELP"
        @study.import_errors = true
        @study.clear_import_cache
        @study.import_cache[:foo].should be_nil
        @study.import_errors.should be_false
      end

      it "should have a place to store import data" do
        @study.import_cache = {:raw => {
          :find_basics => {:study_number => "ABC000123"}, 
          :find_description => {:irb_number => "ABC000123"}
        }}
        @study.import_cache[:raw][:find_basics][:study_number].should == "ABC000123"
      end

      it "should write out the import data as a string" do
        @study.import_cache = {:errors => {:this => "that"}}
        @study.save
        @study.reload
        r = @study.import_cache
        r.is_a?(String).should be_true
        r.should == "errors => {:this=>\"that\"}\n"
      end
    end
    
    describe "importer class" do

      before(:each) do
        @study = Factory(:study, :irb_number => "STU000123")
      end

      it "should import study information" do
        # webservices interfaces should get requests 
        # for data on this study        
        calls = [:find_basics, :find_description, :find_inc_excl, :find_funding_sources]
        calls.each {|k| Eirb.should_receive(k)}
        val = Webservices::Importer.query_study_source(@study.irb_number)
        val[:errors].should == []  
        calls.each {|k| val.keys.include?(k).should be_true}
      end

      it "should import roles information" do
        # ws should get role requests
        calls = [:find_principal_investigators, :find_co_investigators, :find_authorized_personnel] 
        calls.each {|k| Edw.should_receive(k)}
        val = Webservices::Importer.query_roles_source(@study.irb_number)
        val[:errors].should == [] 
        calls.each {|k| val.keys.include?(k).should be_true}
      end

      it "should import involvement information" do 
        @study.managed_by('NOTIS')
        Edw.should_receive(:find_NOTIS_study_subjects)
        val = Webservices::Importer.query_involvements_source(@study.irb_number, @study.managing_system)
        val[:errors].should == []
        val.keys.include?(:find_NOTIS_study_subjects).should be_true
        #checking the other source
        @study.managed_by('ANES')
        Edw.should_receive(:find_ANES_study_subjects)
        val = Webservices::Importer.query_involvements_source(@study.irb_number, @study.managing_system)
        val[:errors].should == []
        val.keys.include?(:find_ANES_study_subjects).should be_true
      end
  
      describe "sanitize imported involvements" do


        it "should sanitize NOTIS data sets" do
          dset = {:find_NOTIS_study_subjects => [{:protocol_id=>"1746", 
            :mrd_pt_id=>"244444444", :ethnicity=>"Non-Hispanic",
            :sex=>"F", :completed_date=>"1/11/2011", :mrn=>"123321",
            :mrn_type=>"NMFF G#", :last_name=>"Smith", :birth_date=>"1/11/1955",
            :address_1=>"50 W. Street", :zip=>"10642", :death_date=>"", :withdrawn_date=>"",
            :patient_created=>"2010-1-10T13:55:23", :irb_number=>"STU000123", 
            :case_number=>"1106", :address_2=>"Apt 106", :patient_id=>"5587555", :race=>"Black",
            :affiliate_id=>"1918", :first_name=>"Traci", :race_ethnicity_created=>"2010-1-10T13:55:23",
            :phone=>"3215551233", :state=>"IL", :city=>"Chicago", :consented_date=>"1/12/2010"}]}
          #Cleaned version below, from above data   
          dset_clean = [{
            :subject => {
              :external_patient_id=>"5587555",
              :nmff_mrn=>"123321",
              :first_name=>"Traci", 
              :last_name=>"Smith", 
              :birth_date=>"1/11/1955", 
              :import_source => 'NOTIS'
             },
            :involvement => {
              :case_number=>"1106",  
              :address_line1=>"50 W. Street", 
              :address_line2=>"Apt 106", 
              :zip=>"10642", 
              :home_phone=>"3215551233", 
              :state=>"IL", 
              :city=>"Chicago", 
              :ethnicity=>"Not Hispanic or Latino",
              :gender=>"Female", 
              :race_is_black_or_african_american => true,
              :involvement_events => {
                :consented_date => "1/12/2010",
                :completed_date => "1/11/2011"}
            }}]
          
          cleaned = Webservices::Importer.sanitize_NOTIS_involvements(dset[:find_NOTIS_study_subjects])
          cleaned.first[:subject].should do |k,v| 
            s = dset_clean.first[:subject][k]
            s.should == v
          end
          cleaned.first[:involvement].each do |k,v|
            s = dset_clean.first[:involvement][k]
            unless s.is_a?(Hash)
              (s == v).should be_true, k
            end
          end
          cleaned.first[:involvement][:involvement_events].should == dset_clean.first[:involvement][:involvement_events]
        end

        it "should sanitize ANES data sets" do 
           dset = {:find_ANES_study_subjects => [{:withdrawn_on=>"", :ethnicity=>"Not Hispanic or Latino",
                :completed_on=>"2011-02-10", :mrn=>"091823888", :last_name=>"MIAOS", :birth_date=>"2/26/1982",
                :gender=>"Female", :case_number=>"105", :race=>"White", :patient_id=>"3672", 
                :first_name=>"LORI", :consented_on=>"2011-02-10"}]}
          #Cleaned version below, from above data   
          dset_clean = [{
            :subject => {
              :external_patient_id=>"3672",
              :nmff_mrn=>"091823888",
              :first_name=>"LORI", 
              :last_name=>"MIAOS", 
              :birth_date=>"2/26/1982", 
              :import_source => 'ANES'
             },
            :involvement => {
              :case_number=>"105",  
              :ethnicity=>"Not Hispanic or Latino",
              :gender=>"Female", 
              :race_is_white => true,
              :involvement_events => {
                :consented_date => "2011-02-10",
                :completed_date => "2011-02-10"}
            }}]
          
          cleaned = Webservices::Importer.sanitize_ANES_involvements(dset[:find_ANES_study_subjects])
          cleaned.first[:subject].should do |k,v| 
            s = dset_clean.first[:subject][k]
            s.should == v
          end
          cleaned.first[:involvement].each do |k,v|
            s = dset_clean.first[:involvement][k]
            unless s.is_a?(Hash)
              (s == v).should be_true, k
            end
          end
          cleaned.first[:involvement][:involvement_events].should == dset_clean.first[:involvement][:involvement_events]

        end

      end

      it "should sanitize roles to remove bad data" do
        bad = {:find_authorized_personnel => [{:netid => "abc123"}]}
        Webservices::Importer.sanitize_roles(bad).should be_empty
        good = {:find_authorized_personnel => [{:netid => "abc123", :project_role => "PI", :consent_role => "Obtaining"}]}
        Webservices::Importer.sanitize_roles(good).should_not be_empty
      end

      # I split the tests this way and added this describe block around 
      # real-er data becuase it was easier to generate test data off the webservices
      # by making actual queries and changing the data than typing out hashes by hand -blc
      describe "with example data taken off the wire" do
        #PHI has been de-id'd
        before(:each) do 
          # taken off the wire
          @example = {
            :find_inc_excl=>[
              {
            :exclusion_criteria=>"Old people", 
            :inclusion_criteria=>"Young people", 
            :irb_number=>"STU00019833", 
            :population_protocol_page=>"N/A",
            :should_not_include => "fake attr"
          }], 
            :find_funding_sources=>[
              {
            :funding_source_category_name=>"Institution", 
            :irb_number=>"STU00019833", 
            :funding_source_name=>"Northwestern", 
            :funding_source_id=>"NU"
          }], 
            :find_basics=>[
              {
            :completed_date=>"", 
            :irb_status=>"Approved", 
            :approved_date=>"12/4/2009", 
            :expired_date=>"12/31/2500 2:00:00 AM", 
            :periodic_review_open=>"false", 
            :expiration_date=>"12/3/2011", 
            :total_subjects_at_all_ctrs=>"", 
            :clinical_trial_submitter=>"", 
            :subject_expected_completion_count=>"", 
            :review_type_requested=>"Full IRB Review", 
            :irb_number=>"STU00019833", 
            :title=>"NUCATS Research Subject Registration System (eNOTIS)", 
            :closed_or_completed_date=>"", 
            :fda_unapproved_agent=>"", 
            :created_date=>"9/24/2009 1:30:37 PM", 
            :accrual_goal=>"", 
            :fda_offlabel_agent=>"", 
            :modified_date=>"11/15/2010 10:50:41 AM", 
            :name=>"N1003-eNOTIS", 
            :research_type=>"Bio-medical", 
            :is_a_clinical_investigation=>"false"
          }], 
            :find_description=>[
              {
            :irb_number=>"STU00019833", 
            :description=>"Description of study"
          }],
            :find_NOTIS_study_subjects => [
              {:protocol_id=>"1746", 
              :mrd_pt_id=>"244444444", :ethnicity=>"Non-Hispanic",
              :sex=>"F", :completed_date=>"1/10/2011", :mrn=>"123321",
              :mrn_type=>"NMFF G#", :last_name=>"Smith", :birth_date=>"1/11/1955",
              :address_1=>"50 W. Street", :zip=>"10642", :death_date=>"", :withdrawn_date=>"",
              :patient_created=>"2010-1-10T13:55:23", :irb_number=>"STU00019833", 
              :case_number=>"1106", :address_2=>"Apt 106", :patient_id=>"5587555", :race=>"White",
              :affiliate_id=>"1918", :first_name=>"Traci", :race_ethnicity_created=>"2010-1-10T13:55:23",
              :phone=>"3215551233", :state=>"IL", :city=>"Chicago", :consented_date=>"1/12/2010"
          }],
            :find_ANES_study_subjects =>[  
              {:withdrawn_on=>"", :ethnicity=>"Not Hispanic or Latino",
                :completed_on=>"2011-02-10", :mrn=>"091823888", :last_name=>"MIAOS", :birth_date=>"2/26/1982",
                :gender=>"Female", :case_number=>"105", :race=>"White", :patient_id=>"3672", 
                :first_name=>"LORI", :consented_on=>"2011-02-10"}, 
                {:withdrawn_on=>"", :ethnicity=>"Not Hispanic or Latino", 
                  :completed_on=>"2011-03-08", :mrn=>"10268233", :last_name=>"Reyer", :birth_date=>"9/17/1978",
                  :gender=>"Female", :case_number=>"111", :race=>"White", :patient_id=>"3737", 
                  :first_name=>"Angelica", :consented_on=>"2011-03-07"}]
          }
        end

        it "should sanitize the data from the study query set" do
          study_hash = Webservices::Importer.sanitize_study(@example)
          study_hash[:completed_date].should be_nil
          study_hash[:irb_status].should == "Approved"
          study_hash[:approved_date].should_not be_nil
          # checking the funding sources are correct
          fs = study_hash[:funding_sources].first
          fs[:name].should == "Northwestern"
          fs[:code].should == "NU"
          fs[:category].should == "Institution"

          # checkin incl/excl criteria
          study_hash[:exclusion_criteria].should == "Old people"
          study_hash[:inclusion_criteria].should == "Young people"
          # checking the descr
          study_hash[:description].should == "Description of study"

          # the fake hash key is not included
          study_hash[:should_not_include].should be_nil
        end

        it "should reject funding sources that are all blank" do 
          @example[:find_funding_sources][0] = {
            :funding_source_category_name=>"", 
            :irb_number=>"STU00019833", 
            :funding_source_name=>"", 
            :funding_source_id=>""
          } 
          study_hash = Webservices::Importer.sanitize_study(@example)
          study_hash[:funding_sources].should be_empty
        end


      end 

      it "should not crash if some queries return empty arrays" do
        example = {
          :find_inc_excl=>[], 
          :find_funding_sources=>[], 
          :find_basics=>[], 
          :find_description=>[]
        }

        study_hash = Webservices::Importer.sanitize_study(example)
        study_hash.each_value do |val|
          val.should be_nil
        end
      end

      describe "error handling" do

        it "should write the error to the data hash if a query fails" do
          Edw.should_receive(:fake_query).and_raise(Exception)
          dval = Webservices::Importer.do_import_queries(Edw,"STU000123",[:fake_query])
          dval[:errors].should_not be_empty
        end
      end
    end
  end
end
