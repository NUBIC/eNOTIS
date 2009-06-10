require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')
require 'webservices/plugins/eirb_services'

describe EirbServices do

  before(:each) do
    @service = EirbServices
    @service.stub!(:connect)
    @params = EirbServices::SEARCH_DEFAULTS
    @search = mock(EirbAdapter) 
  end

  describe "finding data about studies" do 

    it "can find the status of a study by id" do
      p = @params.merge({:savedSearchName => "eNOTIS Study Status", 
                    :parameters => {"ID" => "STU000123"}})
      @search.should_receive(:perform_search).with(p)
      @service.stub!(:eirb_adapter).and_return(@search)
      @service.find_status("STU000123")
    end

    it "can find the details of a study by id" do
      p = @params.merge({:savedSearchName => "eNOTIS Study Basics", 
                    :parameters => {"ID" => "STU000123"}})
      @search.should_receive(:perform_search).with(p)
      @service.stub!(:eirb_adapter).and_return(@search)
      @service.find_by_irb_number("STU000123")
    end

    it "can find the study type for a study" do
      p = @params.merge({:savedSearchName => "eNOTIS Study Research Type", 
                    :parameters => {"ID" => "STU000123"}})
      @search.should_receive(:perform_search).with(p)
      @service.stub!(:eirb_adapter).and_return(@search)
      @service.find_study_research_type("STU000123")
    end  

    it "can find the access list for a study" do
      p = @params.merge({:savedSearchName => "eNOTIS Study Access", 
                    :parameters => {"ID" => "STU000123"}})
      @search.should_receive(:perform_search).with(p)
      @service.stub!(:eirb_adapter).and_return(@search)
      @service.find_study_access("STU000123")

    end

    it "can find all access lists for all protocols" do
      p = @params.merge({:savedSearchName => "eNOTIS Study Access", 
                    :parameters => nil})
      @search.should_receive(:perform_search).with(p)
      @service.stub!(:eirb_adapter).and_return(@search)
      @service.find_study_access()
    end
  end 

  describe "finding data about users" do
     
    it "searches for a user details" do
      p = @params.merge({:savedSearchName => "eNOTIS Person Details", 
                    :parameters => {"NetID" => "abc123"}})
      @search.should_receive(:perform_search).with(p)
      @service.stub!(:eirb_adapter).and_return(@search)
      @service.find_by_netid("abc123")
    end

  end

  it "knows if there is an active eirb connection" do
    @service.should_receive(:eirb_adapter).and_return(nil)
    @service.connected?.should be_false
  end

  it "connects to the service if there is no active connection" do

    @service.stub!(:eirb_adapter).and_return(@search)
    @service.stub(:connected?).and_return(false)
    #watching the connect method
    @service.should_receive(:connect)
    @service.find_by_netid("abc123")

  end
end
