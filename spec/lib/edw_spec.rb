require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Edw do
  it "should assign the class attribute edw_adapter" do
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
  
    describe "finding data about subjects" do
      it "can find the details of a subject by mrn" do
        @adapter.should_receive(:perform_search).with({:mrn => '9021090210'})
        Edw.find_by_mrn(:mrn => '9021090210')
      end
    
      it "can find a list of subjects by name or dob" do
        p = "e-NOTIS+Test+2",{:first_nm => 'July', :last_nm => 'Fourth', :birth_dts => '7/4/50'}
        @adapter.should_receive(:perform_search).with({:first_nm => 'July', :last_nm => 'Fourth', :birth_dts => '7/4/50'})
        Edw.find_by_name_and_dob(:first_name => 'July', :last_name => 'Fourth', :birth_date => '7/4/50')
      end
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
      Edw.find_by_mrn(:mrn => "314")

      Edw.should_receive(:connect)
      Edw.find_by_name_and_dob(:first_name => 'July', :last_name => 'Fourth', :dob => '7/4/50')
    end
  
    it "gives a meaningful error when it can't connect" do
      pending
    end
  end
end
