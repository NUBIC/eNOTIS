require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Webservices do
  before(:each) do
     @patient = Patient.new
     @patient.mrn = "1234"
     @patient.last_name = "local"
     @patient.first_name = "local"
     @patient.save
  end


  it " should return Patient from local db" do
    @patient_2 = Patient.find_by_mrn(mrn)
    @patient_2.first_name.should == "lo"

  end



end
