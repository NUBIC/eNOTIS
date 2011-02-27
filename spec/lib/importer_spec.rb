require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Webservices::Importer do

  describe "Importing a study" do

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

      it "should import subjects information" do
        # Subject information is split accross multiple import sources.
        # Currently two sources, 
        # Also, only certain studies nave study subject data.
        # The import subjects query should take a study number, and 
        # a source ID to query. The source ID is related to the EDW 
        # query not the source (eg not EDW/eIRB as in the study/roles data)
        #
      end

      it "should sanitize roles to remove bad data" do
        bad = {:find_authorized_personnel => [{:netid => "abc123"}]}
        Webservices::Importer.sanitize_roles(bad).should be_empty
        good = {:find_authorized_personnel => [{:netid => "abc123", :project_role => "PI", :consent_role => "Obtaining"}]}
        Webservices::Importer.sanitize_roles(good).should_not be_empty
      end

      describe "with example data taken off the wire" do 

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
          }]
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
