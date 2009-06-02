require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')

describe EirbServices do
  
  describe "search results" do
    it "returns an empty array for a search with no results" do
     empty_search = SoapMockHelper::Search.new.results([])
     @driver.should_receive(:performSearch).and_return(empty_search)
     @tester.find_status_by_id("STU123123123").should == []
    end
    
    it "returns the results as a hash for one row results" do
      payload = [{"ID" => "STU0912301239"}, {"Project State.ID" => "APPROVED"}, {"Name" => "The research study"}, {"Research Type.ID" => "INTERVENTIONAL"}]
      results = SoapMockHelper::Search.new.results(payload)
      @driver.should_receive(:performSearch).and_return(results)
      @tester.find_status_by_id("STU123123123").should == [{"ID" => "STU0912301239", "Project State.ID" => "APPROVED", "Name" => "The research study", "Research Type.ID" => "INTERVENTIONAL"}]
    end
      
    it "returns the results as an array of hashes for multi-row results" do
      payload = [[{"ID" => "STU0912301239"}, {"Project State.ID" => "APPROVED"}, {"Name" => "The research study"}, {"Research Type.ID" => "INTERVENTIONAL"}],
        [{"ID" => "STU01239"}, {"Project State.ID" => "Terminated"}, {"Name" => "The other research study"}, {"Research Type.ID" => "INTERVENTIONAL"}]]
      results = SoapMockHelper::Search.new.results(payload)
      @driver.should_receive(:performSearch).and_return(results)
      # it doesnt matter that this particular method will never return 
      # multiple values. We are just testing the end to end process.
      @tester.find_status_by_id("STU123123123").should == [{"ID" => "STU0912301239", "Project State.ID" => "APPROVED", "Name" => "The research study", "Research Type.ID" => "INTERVENTIONAL"},
        {"ID" => "STU01239", "Project State.ID" => "Terminated", "Name" => "The other research study", "Research Type.ID" => "INTERVENTIONAL"}]
    end
  end
end
