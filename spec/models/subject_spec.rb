require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subject do
  before(:each) do
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
    pending
    # a user actually entered this and we allowed it to go through. It stored it the DB okay
    # but the EDW import process broke.
    s = Subject.new("birth_date" => "19556-06-10")
    s.birth_date.should be_nil
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
