require File.expand_path(File.dirname(__FILE__) '/../spec_helper')

describe MedicalService do

  it "should know if it is 'complete' or not" do
    @ms = MedicalService.create
    @ms.completed?.should be_false
  end
end
