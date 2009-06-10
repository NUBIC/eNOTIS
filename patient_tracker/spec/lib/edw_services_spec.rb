require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'lib/webservices/plugins/edw_services'

describe EdwServices do

  before(:each) do
    service_klass = Class.new do 
      include EdwServices
    end
    
    @adapter = mock(EirbAdapter) 
    @adapter.stub!(:perform_search)
    
    @service = service_klass.new 
    @service.stub!(:connect)
    @service.stub!(:edw_adapter).and_return(@adapter)

  end
  
  describe "finding data about patients" do
    it "can find the details of a patient by mrn" do
      p = {:mrn => '9021090210'}
      @adapter.should_receive(:perform_search).with(p)
      @service.find_by_mrn('9021090210')

    end
    
    it "can find a list of patients by name or dob" do
      p = {:name => 'July Fourth', :dob => '7/4/50'}
      @adapter.should_receive(:perform_search).with(p)
      @service.find_by_name_and_dob("July Fourth", '7/4/50')

    end
  end 
  
  it "always connects" do
    @service.should_receive(:connect)
    @service.find_by_mrn("314")

    @service.should_receive(:connect)
    @service.find_by_name_and_dob("July Fourth", '7/4/50')
  
  end
  
  it "gives a meaningful error when it can't connect" do
    pending
  end
end
