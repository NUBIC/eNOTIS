require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'array'
describe Array do
  before(:each) do
    @a = [ Factory(:involvement, :gender => 2, :ethnicity => 5, :race => 7),
          Factory(:involvement, :gender => 2, :ethnicity => 4, :race => 7),
          Factory(:involvement, :gender => 1, :ethnicity => 3, :race => 8) ]
  end
  it "should count attributes" do
    @a.count_all(:gender).should == [["1",1], ["2",2]]
  end
end
