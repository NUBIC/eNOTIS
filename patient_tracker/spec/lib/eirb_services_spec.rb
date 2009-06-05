require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')
require 'eirb_services'

describe EirbServices do
  
  describe "search results" do
    before(:each) do
      @service = EirbServices::EirbService.new
    end

    it "can find the status of a study by id" do
      @service.find_status_by_id("STU123123123").should == []
      @service.find_status_by_id("STU123123123").should == [{"ID" => "STU00000706", "Project State.ID" => "Approved"} ]
    end
      
  end
end
