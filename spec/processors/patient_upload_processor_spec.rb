require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'chronic'
#require File.dirname(__FILE__) + '/../../app/processors/application'

describe PatientUploadProcessor do
  before(:each) do
    @processor = PatientUploadProcessor.new
  end

  describe "bulk upload" do 
    before(:each) do 
    @dir = File.dirname(__FILE__) + '/../uploads/'
    @study = Study.create({:title=>"some study",:irb_number=>"111115",:synced_at=>Time.now})
    @study_upload = StudyUpload.create({:study_id=>@study.id})
    end

    it "should process a correctly formed csv file" do 

      File.open(@dir + 'valid_upload.csv') do |f|
        @study_upload.upload = f
        @study_upload.save
      end
      @processor.on_message(@study_upload.id)
      Involvement.find_by_study_id(@study.id).should_not be_nil
    end

    it "should ignore a bad mrn if first name, last, name and dob are present" do
      File.open(@dir + 'bad_mrn_valid_name_upload.csv') do |f|
        @study_upload.upload = f
        @study_upload.save
      end
      @processor.on_message(@study_upload.id)
      Involvement.find_by_study_id(@study.id).should_not be_nil
    end

    it "should show all fields not entered" do 
      File.open(@dir + 'missing_values_upload.csv') do |f|
        @study_upload.upload = f
        @study_upload.save
      end
      upload_id = @study_upload.id
      @processor.on_message(upload_id)
      @study_upload = StudyUpload.find(upload_id)
      result = File.new(@study_upload.result.path,"r")
      content = result.readlines() 
      content.to_s.should =~ /either MRN or First Name, Last Name and Date of Birth are required/i 
      content.to_s.should =~ /Race is required/i 
      content.to_s.should =~ /Gender is required/i 
      content.to_s.should =~ /Ethnicity is required/i 
      content.to_s.should =~ /Event Type is required/i 
      content.to_s.should =~ /Event Type is required/i 
    end

    it "should report all improperly entered races, ethnicities and involvement types" do
      File.open(@dir + 'invalid_race_etc_upload.csv') do |f|
       @study_upload.upload = f
       @study_upload.save
      end
      upload_id = @study_upload.id
      @processor.on_message(upload_id)
      @study_upload = StudyUpload.find(upload_id)
      result = File.new(@study_upload.result.path,"r")
      content = result.readlines() 
      content.to_s.should =~ /Unknown Ethnicity Value/i
      content.to_s.should =~ /Unknown Race Value/i 
      content.to_s.should =~ /Unknown Event Type/i
      content.to_s.should =~ /Unknown Gender Value/i 
    end

    it "should input multiple races if entered" do 
      File.open(@dir + 'valid_upload.csv') do |f|
        @study_upload.upload = f
      end
      @study_upload.save
      @processor.on_message(@study_upload.id)
      Involvement.find_by_study_id(@study.id).races.size.should == 2
    end

    it "should input multiple involvements if entered" do
      File.open(@dir + 'valid_upload.csv') do |f|
        @study_upload.upload = f
      end
      @study_upload.save
      @processor.on_message(@study_upload.id)
      Involvement.find_by_study_id(@study.id).involvement_events.size.should == 2
    end

    it "should not create duplicate involvement events" do 
      File.open(@dir + 'duplicate_events_upload.csv') do |f|
        @study_upload.upload = f
        @study_upload.save
      end
      @processor.on_message(@study_upload.id) 
      puts Involvement.find(:all).inspect
      Involvement.find_by_study_id(@study.id).involvement_events.size.should == 1
    end

    it "Should not create duplicate patients (same name and dob)  on the same study" do
      File.open(@dir + 'valid_upload.csv') do |f|
        @study_upload.upload = f
      end
      @study_upload.save
      @study_upload2 = StudyUpload.create({:study_id=>@study.id})
      
      File.open(@dir + 'valid_upload.csv') do |f|
        @study_upload2.upload = f
      end
      @study_upload2.save
      @processor.on_message(@study_upload2.id.to_s)
      @study.involvements.size.should == 1
    end
   
  

  end
end
