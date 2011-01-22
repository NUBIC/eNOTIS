require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MedicalService do

  it "should know if it is 'complete' or not" do
    ms = MedicalService.create
    ms.completed?.should be_false
  end

  describe "options for completness" do

    it "should be complete for case 1" do
      c1 = MedicalService.create
      c1.current_enrollment = 0
      c1.expected_enrollment = 0
      c1.expected_clinical_services = 0
      c1.uses_services_before_completed = false
      c1.completed?.should be_true
    end
    
    it "should be complete for case 2" do
      c2 = MedicalService.create
      c2.current_enrollment = 10
      c2.expected_enrollment = 10
      c2.expected_clinical_services = 10
      c2.uses_services_before_completed = true
      c2.completed?.should be_false
      
      c2.expects_bedded_outpatients = false
      c2.expects_bedded_inpatients = false
      c2.involves_pharmacy = false
      c2.involves_labs_pathology = false
      c2.involves_imaging = false
      c2.completed?.should be_true
    end

    it "should be complete for case 3" do
      c3 = MedicalService.create
      c3.current_enrollment = 10
      c3.expected_enrollment = 10
      c3.expected_clinical_services = 10
      c3.uses_services_before_completed = true
      c3.completed?.should be_false
      
      c3.expects_bedded_outpatients = false
      c3.expects_bedded_inpatients = true #TRUE!!!
      c3.involves_pharmacy = false
      c3.involves_labs_pathology = false
      c3.involves_imaging = false
      c3.completed?.should be_false

      c3.bedded_inpatient_days_research = 3
      c3.bedded_inpatient_days_standard_care = 0
      c3.completed?.should be_true
    end
  end

  it "should set the completed date on save if the form is completed" do
      c1 = MedicalService.create
      c1.current_enrollment = 0
      c1.expected_enrollment = 0
      c1.expected_clinical_services = 0
      c1.uses_services_before_completed = false
      c1.completed?.should be_true
      c1.completed_at.should be_nil
      c1.save!
      c1.completed_at.should_not be_nil
  end
end

