require File.dirname(__FILE__) + '/../spec_helper'

describe WebServices do
  before(:each) do
     @patient = Patient.new
     @patient.mrn = "1234"
     @patient.last_name = "local"
     @patient.first_name = "local"
     @patient.save
  end


  it " should return Patient from local db if it exists" do
    @patient_2 = Patient.find_by_mrn("1234")
    @patient_2.first_name.should == "local"

  end

  it "should retrieve patient from edw if it does not exist locally" do
    @patient_3 = Patient.find_by_mrn("success")
    @patient_3.mrn.should == "success"
  end





end
