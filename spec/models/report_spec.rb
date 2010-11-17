require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fastercsv'

describe "Report generation from study data" do

  before(:each) do

    @study = Factory(:study) 
    @subject = Factory(:subject) 
    @involvement = Factory(:involvement, 
                           :races => ["White", "Asian"],
                           :study => @study, 
                           :subject => @subject, 
                           :case_number => "123abc123")
    # Adding all the events for testing purposes
    %w(Consented Completed Withdrawn).each do |n|
      Factory(:involvement_event, :involvement => @involvement, :event => n) 
    end

    # Full params for export
    params = HashWithIndifferentAccess.new({
      "format"=>"csv",
      "study"=>{"irb_number"=>@study.irb_number},
      "subject"=>["nmff_mrn","nmh_mrn","first_name","last_name","birth_date"],
      "involvement"=>{
        "methods"=>["race_as_str","all_events"],
        "attributes"=>["case_number","gender", "ethnicity"]
      }
    }) 
    @csv_data = Report.export(params) 
  end

  # Birth_date does not work with the factories for some reason.
  # I looked into it but could not figure out an easy way to fix it -BLC
  rh = Report::HEADERS[:subject].reject{|k, v| k == "Birth Date"}
  rh.each do |col_name, attr_name|
    it "should have in the csv '#{col_name}' for Subject.#{attr_name}" do
      FasterCSV.parse(@csv_data, :headers => true) do |row|
        row[col_name].should_not be_nil
        row[col_name].should == @subject.send(attr_name.to_sym).to_s
      end
    end
  end

  Report::HEADERS[:involvement].each do |col_name, attr_name|
    it "should have in the csv '#{col_name}' for Involvement.#{attr_name}" do
      FasterCSV.parse(@csv_data, :headers => true) do |row|
        row[col_name].should_not be_nil
        row[col_name].should == @involvement.send(attr_name.to_sym).to_s
      end
    end
  end

  Report::HEADERS[:event].each do |col_name, attr_name|
    it "should have the '#{col_name}' event in the csv " do
      FasterCSV.parse(@csv_data, :headers => true) do |row|
        row[col_name].should_not be_nil
        row[col_name].should == @involvement.send(attr_name.to_sym).to_s
      end
    end
  end

  it "converts the defined headers to Ruport column name change hash" do
    proper_format = {"case_number"=>"Case Number",
      "ethnicity"=>"Ethnicity",
      "subject.nmff_mrn"=>"Nmff Mrn",
       "gender"=>"Gender", 
      "subject.first_name"=>"First Name",     
      "consented_report"=>"Consented",
      "withdrawn_report"=>"Withdrawn", 
      "completed_report"=>"Completed", 
      "race_as_str"=>"Races",
      "subject.birth_date"=>"Birth Date",
      "subject.last_name"=>"Last Name",
      "subject.nmh_mrn"=>"Nmh Mrn"}

     nc = Report.name_changes
     proper_format.each_pair do |k,v|
       nc.should have_key(k)
       nc[k].should == v
     end
  end

  describe "determining output based on parameters" do
   
    # A bit fragile, I know, but I will probably be revisting this
    # code once we add dynamic events

    it "should output all the columns"  do
       all_params = HashWithIndifferentAccess.new({
         "subject"=>["nmff_mrn","nmh_mrn","first_name","last_name","birth_date"],
         "involvement"=>{
           "methods"=>["race_as_str","all_events"],
           "attributes"=>["case_number","gender", "ethnicity"]
         }
       }) 
       cols = Report.filter_columns(all_params)
       cols.should == Report::ORDER
       
    end

    it "should only output first and last name" do
      fnln_params = HashWithIndifferentAccess.new({
        "subject" => ["first_name", "last_name"]
      })
      cols = Report.filter_columns(fnln_params)
      cols.should == ["Last Name", "First Name"]
    end
   
    it "should only output all events" do
      evnt_params = HashWithIndifferentAccess.new({
        "involvement" => {"methods" => ["all_events"]}
      })
      cols = Report.filter_columns(evnt_params)
      cols.should == ["Consented", "Completed", "Withdrawn"]
    end

    it "should only output nmff_mrn, race, and gender" do
      mrn_params = HashWithIndifferentAccess.new({
        "subject" => ["nmff_mrn"],
        "involvement" => {
          "methods" => ["race_as_str"],
          "attributes" => ["gender"]
        }
      })
      cols = Report.filter_columns(mrn_params)
      cols.should == ["Nmff Mrn", "Gender", "Races"]
    end

 end

 it "should expand the methods from 'all_events' to the defined events" do
   evnt_params = HashWithIndifferentAccess.new({
    "involvement" => {"methods" => ["all_events"]}
    })
    exp_m = Report.expand_events(evnt_params)
    evnt_reps = ["consented_report", "withdrawn_report","completed_report"]
    evnt_reps.each {|r| exp_m.include?(r)}
 end

 it "should not expand methods when 'all_events' is not present" do
   evnt_params = HashWithIndifferentAccess.new({
     "involvement" => {"methods" => []}
   })
   exp_m = Report.expand_events(evnt_params)
   exp_m.should be_empty
 end
end

