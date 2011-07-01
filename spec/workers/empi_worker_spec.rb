require 'spec_helper'

describe EmpiWorker do
  describe "find failure" do
    before(:each) do
      EMPI_SERVICE = {}
      Empi.stub!(:connect).and_return(true)
    end
    
    it "should log record no longer exists and complete successfully" do
      EmpiWorker.perform(-99999999)
    end
  end
end
