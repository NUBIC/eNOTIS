require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

#require File.dirname(__FILE__) + '/../../app/processors/application'

describe PatientUploadProcessor do
  before(:each) do
    @processor = PatientUploadProcessor.new
  end

  describe "bulk upload" do 

  end


  describe "Subject Finder" do
    it "should return nil subject with reason if invalid mrn is given" do
      r = {:mrn=>"were"}
      @processor.get_upload_patient(r).should == {:subject=>nil, :comments=>"unkown mrn"}
    end

    it "should return nil with error if no mrn and incomplete patient data is given" do 
      r = {:birth_date=>'12/12/1984'}
      @processor.get_upload_patient(r).should == {:subject=>nil,:comments=>"invalid input data"}
    end
 
    it "should return nil if multiple patients are found in the edw" do 
      r = {:birth_date=>"6/12/1954",:first_name=>"test",:last_name=>"last"}
      @processor.get_upload_patient(r).should == {:subject=>nil,:comments=>"multiple edw patients found"}
    end

    it "should return a new subject with comments if subject doesn't exist in the edw" do
      r = {:birth_date=>"12/12/1981",:first_name=>"James",:last_name=>"kinuthia"}
      result = @processor.get_upload_patient(r)
      result[:comments].should == "created new patient" 
    end

    it "should return edw subject if correct mrn is provided" do
      r ={:mrn=>"9988167"}
      result = @processor.get_upload_patient(r)
      result[:comments].should == nil
    end
  end

end
