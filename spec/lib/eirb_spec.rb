require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')

describe Eirb do
  
   it "should assign the class attribute eirb_adapter" do
    File.stub!(:read).and_return("")
    EirbAdapter.stub!(:new).and_return("foo")
    Eirb.connect
    Eirb.eirb_adapter.should_not be_nil
  end
  
  describe "with stubbed adapter" do
    before(:each) do
      @service = Eirb
      @service.stub!(:connect)
      @params = Eirb::SEARCH_DEFAULTS
      @search = mock(EirbAdapter) 
    end

    describe "finding data about studies" do 
      Eirb::STORED_SEARCHES.each do |search|
        it "has the dynamic find methods" do
          p = @params.merge({:savedSearchName => search[:name], 
                        :parameters => {"ID" => "STU000123"}})
          @search.should_receive(:perform_search).with(p)
          @service.stub!(:eirb_adapter).and_return(@search)
          @service.send("find_#{search[:ext]}", {:irb_number=>"STU000123"})
        end
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
      @service.find_basics("STU00000123")

    end
  end
  describe "converter should return appropriate values" do
    it "should return the corresponding values in the translator hash" do
      @converter = {"attribute1"=>"attribute1_converted","attribute2"=>"attribute2_converted"}
      Webservices.convert([{"attribute1"=>"test1","attribute2"=>"test2"}],@converter).should == [{:attribute1_converted=>"test1",:attribute2_converted=>"test2"}]
    end

    it "should ignore any attribute that doesn't exist in the translator" do
       @converter = {"attribute1"=>"attribute1_converted","attribute2"=>"attribute2_converted"}
       Webservices.convert([{"attribut"=>"test1","attribute2"=>"test2"}],@converter).should == [{:attribute2_converted=>"test2"}]
    end

  end
end
