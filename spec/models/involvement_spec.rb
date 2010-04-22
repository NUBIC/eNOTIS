require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Involvement do
  before(:each) do
    @involvement = Factory(:involvement)
  end

  it "should create a new instance given valid attributes" do
    @involvement.should be_valid
  end
  it "should accept gender, ethnicity, and race (case insensitive) and set the right case" do
    Involvement.new(:gender => "FEMALE").gender.should == "Female"
    Involvement.new(:gender => "m").gender.should == nil
    Involvement.new(:ethnicity => "HiSpAnIc Or LaTiNo").ethnicity.should == "Hispanic or Latino"
    Involvement.new(:race => "asian").race.should == "Asian"
  end
  
  it "should handle two digit years in dates" do
    @involvement.update_attributes("subject_attributes"=> {"birth_date"=>"12/18/34"})
    @involvement.subject.birth_date.should == Date.parse("1934-12-18")
    
    @involvement.update_attributes("subject_attributes"=> {"birth_date"=>"12/18/07"})
    @involvement.subject.birth_date.should == Date.parse("2007-12-18")
  end
end
