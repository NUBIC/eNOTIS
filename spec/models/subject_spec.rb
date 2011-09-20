require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subject do
 
  it "has a nice class method to help us remember to scope searches by external patient/subject/participant ids by the source system" do
    subj1 = Factory(:subject, :external_patient_id => '123', :import_source => 'ANES')
    subj2 = Factory(:subject, :external_patient_id => '123', :import_source => 'NOTIS')
    found = Subject.find_by_external_id('123', 'NOTIS')
    found.id.should == subj2.id
    found.id.should_not == subj1.id
  end

  it "should create a new instance given valid attributes" do
    Factory(:subject).should be_valid
  end
  
  it "should handle two digit years in dates" do
    Subject.new("birth_date"=>"12/18/34").birth_date.should == Date.parse("1934-12-18")
    Subject.new("birth_date"=>"12/18/07").birth_date.should == Date.parse("2007-12-18")
  end

  # TODO:consider similar constraints on death_date? 

  it "should not accept crazy birthdate from the future" do
    #pending
    # a user actually entered this and we allowed it to go through. It stored it the DB okay
    # but the EDW import process broke.
    s = Subject.create("birth_date" => Date.tomorrow.to_s)
    s.id.should be_nil
    # And there should be errors
    s.should have(1).errors_on(:birth_date)
  end

  it "should not accept a crazy bithdate from the past" do
    pending
    s = Subject.new("birth_date" => "921-03-29")
    s.birth_date.should be_nil
    s.should have(1).errors_on(:birth_date)
  end

end
