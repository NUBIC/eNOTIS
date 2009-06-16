require File.dirname(__FILE__) + '/../spec_helper'

describe WebServices do
  before(:each) do
     @subject = Subject.new
     @subject.mrn = "1234"
     @subject.last_name = "local"
     @subject.first_name = "local"
     @subject.save
  end
  it " should return Subject from local db if it exists" do
    @subject_2 = Subject.find_by_mrn("1234")
    @subject_2.first_name.should == "local"

  end
  it "should retrieve subject from edw if it does not exist locally" do
    @subject_3 = Subject.find_by_mrn("success")
    @subject_3.mrn.should == "success"
  end





end
