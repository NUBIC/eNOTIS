require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fastercsv'

def up(name, extension = 'csv')
  File.open(File.dirname(__FILE__) + "/../uploads/#{name}.#{extension}")
end

describe StudyUpload do
  it "should create a new instance given valid attributes" do
    Factory(:study_upload).should be_valid
  end
  
  it "should sort descending by created at" do
    study = Factory(:study)
    su1 = Factory(:study_upload, :study => study)
    su2 = Factory(:study_upload, :study => study)
    study.study_uploads.should == [su2, su1]
  end
  
  it "should fail if upload is blank" do
    @up = StudyUpload.new(:netid => "abc234", :study_id => 2, :upload => nil)
    @up.legit?.should be_false
    @up.summary.should =~ /Please upload a file/
  end
  
  it "should fail if upload doesn't have valid columns" do
    @up = Factory(:study_upload, :upload => up('missing_columns'))
    @up.legit?.should be_false
    @up.summary.should =~ /missing required columns/
  end
  
  it "should fail if upload is in excel format" do
    @up = Factory(:study_upload, :upload => up('excel', 'xls'))
    @up.legit?.should be_false
    @up.summary.should =~ /a valid CSV file/
  end
  
  it "should fail if upload is in xlsx format" do
    @up = Factory(:study_upload, :upload => up('excel', 'xlsx'))
    @up.legit?.should be_false
    @up.summary.should =~ /a valid CSV file/
  end

  it "should succeed even if upload has weird encodings" do
    @up = Factory(:study_upload, :upload => up('encoding'))
    @up.create_subjects.should be_true
    @up.summary.should =~ /1 subjects/
    @up.study.involvements.should have(1).subjects
  end

  it "should have errors if upload has blank or invalid race, ethnicity, or gender values" do
    @up = Factory(:study_upload, :upload => up('blank_terms'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
    @up = Factory(:study_upload, :upload => up('bad_terms'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
  end
  
  it "should have errors if mrn, fn/ln/dob, case number are missing" do
    @up = Factory(:study_upload, :upload => up('missing_identifiers'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
  end
  
  it "should have errors if there are no event dates" do
    @up = Factory(:study_upload, :upload => up('blank_event_dates'))
    @up.legit?.should be_false
    @up.summary.should =~ /and fix/
  end
end 
describe "should be successful with a good csv and store the data it is supposed to!" do

  before(:each) do
    StudyUpload.count.should == 0
    @up = Factory(:study_upload, :upload => up('single_subject_good'))
    @study = @up.study
  end

  it "should actually upload the file" do
    @up.upload_exists?.should be_true
  end

  it "parses the upload" do
    @up.parse_upload.should be_true
  end

  it "creates the subjects" do
    @up.create_subjects.should be_true
    @up.summary.should =~ /1 subjects/
    @study.involvements.should have(1).subjects
  end
end
describe "checking the data against the upload" do 
  # Header, for example:
  # <FasterCSV::Row "Case Number":"14212" "NMFF MRN":nil "NMH MRN":nil "RIC MRN":nil "First Name":"Meghan" "Last Name":"O'Keefe"
  # "Birth Date":"1/3/1956" "Gender":"Female" "Race":"Unknown or Not Reported" "Ethnicity":"Unknown or Not Reported" 
  # "Consented On":"1/2/2010" "Consented Note":nil "Withdrawn On":"5/4/2010" "Withdrawn Note":nil "Completed On":nil 
  # "Completed Note":nil>
  
  before(:each) do
    @up = Factory(:study_upload, :upload => up('single_subject_good'))
    @study = @up.study
    
    @up.create_subjects.should be_true
    @up.summary.should =~ /1 subjects/
    @inv = @study.involvements.first
    @csv = FasterCSV.parse(up('single_subject_good'), :headers => true)
    @row = @csv[0]
  end

  it "has the correct subject data" do
    @row["Case Number"].should == @inv.case_number  
    @row["First Name"].should == @inv.subject.first_name
    @row["Last Name"].should  == @inv.subject.last_name
    @row["Birth Date"].should == @inv.subject.birth_date.strftime("%m/%d/%Y")
  end

  it "has the correct race, gender, etc" do
    @row["Gender"].should == @inv.gender
    @row["Race"].should == @inv.race.to_s
    @row["Ethnicity"].should == @inv.ethnicity
  end

  it "has the correct events" do
    c_event = @inv.event_detect("Consented")
    c_event.occurred_on.strftime("%m/%d/%Y").should == @row["Consented On"]
    w_event = @inv.event_detect("Withdrawn")
    w_event.occurred_on.strftime("%m/%d/%Y").should == @row["Withdrawn On"]
  end
end
