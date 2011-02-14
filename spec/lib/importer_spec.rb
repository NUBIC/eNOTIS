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
        Webservices::Importer.should_receive(:query_study_source).and_return({:name => "The study"})
        Webservices::Importer.should_receive(:query_roles_source).and_return([{:netid => "abc154", :project_role => "PI", :consent_role => "None"}])
        Webservices::Importer.import_external_study_data(@study)
        @study.imported_since?(ts).should be_true
      end
     
      it "should clear the import cache" do
        @study.import_results = {:foo => "HELP"}
        @study.import_results[:foo].should == "HELP"
        @study.clear_import_cache
        @study.import_results[:foo].should be_nil
      end

      it "should have a place to store import data" do
        @study.import_results = {:raw => {
          :find_basics => {:study_number => "ABC000123"}, 
          :find_description => {:irb_number => "ABC000123"}
        }}
        @study.import_results[:raw][:find_basics][:study_number].should == "ABC000123"
      end
    end
    
    describe "importer class" do

      before(:each) do
        @study = Factory(:study, :irb_number => "STU000123")
      end

      it "should import study information" do
        # webservices interfaces should get requests 
        # for data on this study        
        Eirb.should_receive(:find_basics)
        Eirb.should_receive(:find_description)
        Eirb.should_receive(:find_inc_excl)
        Eirb.should_receive(:find_funding_sources)
        Webservices::Importer.query_study_source(@study.irb_number)
      end

      it "should import roles information" do
        # ws should get role requests
        Edw.should_receive(:find_principal_investigators)
        Edw.should_receive(:find_co_investigators)
        Edw.should_receive(:find_authorized_personnel)
        Webservices::Importer.query_roles_source(@study.irb_number)
      end

      it "should import subjects information" do
        pending
      end

      it "should sanitize roles to remove bad data" do
        bad = [{:netid => "abc123"}]
        Webservices::Importer.sanitize_roles(bad).should be_empty
        good = [{:netid => "abc123", :project_role => "PI", :consent_role => "Obtaining"}]
        Webservices::Importer.sanitize_roles(good).should_not be_empty
      end
  
      describe "error handling" do

        it "should write the error to the data hash if a query fails" do
          Edw.should_receive(:fake_query).and_raise(Exception)
          Webservices::Importer.do_import_queries(Edw,"STU000123",[:fake_query])
        end
      end
    end
  end
end
