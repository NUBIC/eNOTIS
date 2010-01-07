require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'array'
describe Array do
  before(:each) do
    @a = [ Factory(:involvement, :gender_type_id => 2, :ethnicity_type_id => 5, :race_type_ids => [7,8,9]),
          Factory(:involvement, :gender_type_id => 2, :ethnicity_type_id => 4, :race_type_ids => [7]),
          Factory(:involvement, :gender_type_id => 1, :ethnicity_type_id => 3, :race_type_ids => [8]) ]
  end
  it "should count attributes" do
    @a.count_all(:gender_type_id).should == [["1",1], ["2",2]]
  end
  it "should count array attributes" do
    @a.count_all(:races, :race_type_id).should == [["7",2], ["8",2], ["9", 1]]
  end
end
