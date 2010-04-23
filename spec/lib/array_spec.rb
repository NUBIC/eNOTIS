require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'array'
describe Array do
  before(:each) do
    @a = [ Factory(:involvement, :gender => "Male", :ethnicity => "Hispanic or Latino", :race => "Asian"),
          Factory(:involvement, :gender => "Male", :ethnicity => "Hispanic or Latino", :race => "Asian"),
          Factory(:involvement, :gender => "Female", :ethnicity => "Not Hispanic or Latino", :race => "White") ]
  end
  it "should count attributes" do
    @a.count_all(:gender).should == [["Female",1], ["Male",2]]
  end
end
