require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

#require File.dirname(__FILE__) + '/../../app/processors/application'

describe PatientUploadProcessor do
  before(:each) do
    @processor = PatientUploadProcessor.new
  end

  describe "bulk upload" do 
    before(:each) do 
    @dir = File.dirname(__FILE__) + '/../uploads/'
    @study = Study.create(:title=>"some study")
    @study_upload = StudyUpload.create({:study_id=>@study.id})
    end
    it "should process a correct mrn and return values" do 
      good_mrn = File.open(@dir + 'good_mrn.csv')
      @study_upload.upload = good_mrn
      good_mrn.close
      @study_upload.save
      @processor.on_message(@study_upload.id.to_s)
      Involvements.find_by_study_id(@study.id).size.should == 0
    end

    it "should fail to process an entry with an incorrect mrn" do
      #Subject.stub!(:find).and_return(nil)
      #bad_mrn = File.open(@dir + 'bad_mrn.csv')
      #@study_upload.upload = bad_mrn
      #bad_mrn.close
      #@study_upload.save
      #@processor.on_message(@study_upload.id)
      #Involvements.find_by_study_id(@study.id).size.should == 0 
    end
    
  end


  describe "Subject Finder" do
    before(:each) do 
      
    end
    it "should return nil subject with reason if invalid mrn is given" do
      r = {:mrn=>"were"}
      Subject.stub!(:find).and_return(nil)
      @processor.get_upload_patient(r).should == {:subject=>nil, :comments=>"unkown mrn"}
    end

    it "should return nil  if no mrn and incomplete patient data is given" do 
      r = {:birth_date=>'12/12/1984'}
      @processor.get_upload_patient(r).should == {:subject=>nil,:comments=>nil}
    end
 
    it "should return nil if multiple patients are found in the edw" do 
      Subject.stub!(:find).and_return([Subject.create,Subject.create])
      r = {:birth_date=>"6/12/1954",:first_name=>"test",:last_name=>"last"}
      result = @processor.get_upload_patient(r)
      result[:comments].should == "multiple edw patients found"
    end

    it "should return a new subject with comments if subject doesn't exist in the edw" do
      Subject.stub!(:find).and_return([])
      r = {:birth_date=>"12/12/1981",:first_name=>"James",:last_name=>"kinuthia"}
      result = @processor.get_upload_patient(r)
      result[:comments].should == "created new patient" 
    end

    it "should return edw subject if correct mrn is provided" do
      Subject.stub!(:find).and_return(Subject.create(:mrn=>"9988167"))
      r ={:mrn=>"9988167"}
      result = @processor.get_upload_patient(r)
      result[:comments].should == nil
    end
  end

end
