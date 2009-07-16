require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Involvement do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:involvement).should be_valid
  end
  
  describe "Accessing involvement data elements" do

    describe "race data" do
      it "has not reported race category" do
        inv = Factory(:involvement)
        inv.race.should be_nil
      end
      
      it "has reported a race category" do
        inv = Factory(:involvement)
        inv.race = "Klingon"
        inv.race.should == "Klingon"
      end

    end

  end
end
