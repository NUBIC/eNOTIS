require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fastercsv'

describe "Report generation from study data" do

  before(:each) do

    @study = Factory(:study)
    @study.create_default_events
    @subject = Factory(:subject)
    @involvement = Factory(:involvement,
                           :races => ["White", "Asian"],
                           :study => @study,
                           :subject => @subject,
                           :case_number => "123abc123")
    # Adding all the events for testing purposes
    @study.event_types.each do |ev|
      Factory(:involvement_event, :involvement => @involvement, :occurred_on => 1.day.ago, :event_type => ev)
    end

    @headers = ['id','case_number','ethnicity','gender','first_name','last_name','nmh_mrn','ric_mrn','nmff_mrn','races']
    # Full params for export
    params = HashWithIndifferentAccess.new({
      "type"=>"subjects",
      "study"=>{"irb_number"=>@study.irb_number}
      })
    @csv_data = Report.export(params)[:report]
  end

  # Birth_date does not work with the factories for some reason.
  # I looked into it but could not figure out an easy way to fix it -BLC
  ['id','case_number','ethnicity','gender','first_name','last_name','nmh_mrn','ric_mrn','nmff_mrn','races'].each do |col_name|
    it "should have in the csv '#{col_name}' for Involvement.#{col_name}" do
      FasterCSV.parse(@csv_data, :headers => true) do |row|
        row[col_name].should_not be_nil
        row[col_name].should == @involvement.send(col_name.to_sym).to_s
      end
    end
  end

  EventType::DEFAULT_EVENTS.keys.each do |name|
    it "should have the '#{name}' event in the csv " do
      event_type = @study.event_types.find_by_name(name)
      FasterCSV.parse(@csv_data, :headers => true) do |row|
        row[event_type.name].should_not be_nil
        row[event_type.name].should == @involvement.event_dates(event_type).join(":")
      end
    end
  end

end

