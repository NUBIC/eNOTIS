require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Edw do
  it "should assign the class attribute edw_adapter" do
    WebserviceConfig.stub!(:new).and_return({:url => "https://www.foo.com"})
    Edw.connect
    Edw.edw_adapter.should_not be_nil
  end
  
  describe "with stubbed adapter" do
    before(:each) do
      @adapter = mock(EirbAdapter) 
      @adapter.stub!(:perform_search)

      Edw.stub!(:connect)
      Edw.stub!(:edw_adapter).and_return(@adapter)
    end

   describe "converting attributes from provided hashes" do
      it "should provide the converted attribute for each attribute provided that exists in the translator" do
         @converter = {"attribute1"=>"attribute1_converted","attribute2"=>"attribute2_converted"}
         Webservices.convert([{"attribute1"=>"test1","attribute2"=>"test2"}],@converter).should == [{:attribute1_converted=>"test1",:attribute2_converted=>"test2"}]
      end

      it "should ignore any attribute that doesn't exist in the translator" do
         @converter = {"attribute1"=>"attribute1_converted","attribute2"=>"attribute2_converted"}
         Webservices.convert([{"attribut"=>"test1","attribute2"=>"test2"}],@converter).should == [{:attribute2_converted=>"test2"}]
      end 
   end 
  
    it "always connects" do
      Edw.should_receive(:connect)
      Edw.find_principal_investigators(:irb_number => "STU0000314")
    end
  
  end
end
