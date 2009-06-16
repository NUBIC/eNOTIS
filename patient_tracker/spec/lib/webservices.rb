require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Webservices do
  before(:each) do
     @subject = Subject.new
     @subject.mrn = "1234"
     @subject.last_name = "local"
     @subject.first_name = "local"
     @subject.save
  end


  it " should return Subject from local db" do
    @subject_2 = Subject.find_by_mrn(mrn)
    @subject_2.first_name.should == "lo"

  end



end
