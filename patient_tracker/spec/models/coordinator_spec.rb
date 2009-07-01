require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Coordinator do
  before(:each) do
    @valid_attributes = {}
  end

  it "should create a new instance given valid attributes" do
    Factory(:coordinator).should be_valid
  end

  describe "importing coordinators" do
    
    before(:all) do
      @list = [{:netid => "abc123", :irb_number => "STU0124402"},
      {:netid => "ddc333", :irb_number => "STU0001233"}]
    end

    it "takes calls the webservice to get the import list" do
      pending
      EirbServices.should_recieve(:find_study_access).and_return(@list)
    end


  end

end
