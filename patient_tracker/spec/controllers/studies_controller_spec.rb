require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudiesController do

  it "should use the irb_number of a study in the path" do
    @study = Factory(:study, :irb_number => "stu5318008")
    study_path(@study).should == "/studies/stu5318008"
  end

end
