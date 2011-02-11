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
        Webservices::Importer.should_receive(:import_base_study_data).with(@study).and_return(true)
        Webservices::Importer.import_external_study_data(@study)
        @study.imported_since?(ts).should be_true
      end

      it "should have a place to store import errors" do
        @study.import_errors = {:find_basics => "LOGIN FAILED"}
        @study.import_errors[:find_basics].should == "LOGIN FAILED"
      end

      it "should overwrite previous errors" do 
        @study.import_errors = {:find_basics => "LOGIN FAILED"}
        @study.import_errors = {:find_basics => "CONTENT LIMITED"}
        @study.import_errors[:find_basics].should == "CONTENT LIMITED"
      end

      it "should clear the errors" do
        @study.import_errors = {:foo => "HELP"}
        @study.import_errors[:foo].should == "HELP"
        @study.clear_import_cache
        @study.import_errors[:foo].should be_nil
      end

      it "should have a place to store import data" do
        @study.import_results = {:find_basics => {
          :raw => {:study_number => "ABC000123"}, 
          :clean => {:irb_number => "ABC000123"}
        }}
        @study.import_results[:find_basics][:raw][:study_number].should == "ABC000123"
      end
    end
    
    describe "importer class" do

      before(:each) do
        @study = Factory(:study, :irb_number => "STU000123")
      end

      it "should import study information" do
        Eirb.should_receive(:find_basics)
        Eirb.should_receive(:find_description)
        Eirb.should_receive(:find_inc_excl)
        Eirb.should_receive(:find_funding_sources)
        # webservices interfaces should get requests 
        # for data on this study
        Webservices::Importer.query_study_source(@study.irb_number)
      end

      it "should import roles information" do
        Edw.should_receive(:find_principal_investigators)
        Edw.should_receive(:find_co_investigators)
        Edw.should_receive(:find_authorized_personnel)
        Webservices::Importer.query_roles_source(@study.irb_number)
      end

      it "should import subjects information" do
        pending
      end

    end
  end
end
