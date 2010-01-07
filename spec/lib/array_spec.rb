require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'array'
describe Array do
  before(:each) do
    @a = [ Factory(:involvement, :gender_type_id => 2, :ethnicity_type_id => 5),
          Factory(:involvement, :gender_type_id => 2, :ethnicity_type_id => 4),
          Factory(:involvement, :gender_type_id => 1, :ethnicity_type_id => 3) ]
  end
  it "should count attributes" do
    @a.count_all(:gender_type_id).should == {:gender_type_id => {:"2" => 2, :"1" => 1}}
  end
  it "should count multiple attributes" do
    @a.count_all(:ethnicity_type_id, :gender_type_id).should == {:gender_type_id => {:"2" => 2, :"1" => 1}, :ethnicity_type_id => {:"3" => 1, :"4" => 1, :"5" => 1}}
  end
end
