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
      c1.save.should be_true
      c1.completed_at.should_not be_nil
  end

  it "should work for both these test cases (pulled from real expamles which caused crash)" do
  #{"medical_service":{"completed_at":null,"bedded_inpatient_days_research":null,"current_enrollment":2,"created_at":"2011-01-26T07:48:32Z","contact_name":null,"expected_enrollment":null,"updated_at":"2011-01-26T07:54:53Z","expected_clinical_services":null,"expects_bedded_outpatients":null,"expects_bedded_inpatients":null,"id":1,"study_id":4631,"involves_pharmacy":null,"involves_labs_pathology":null,"involves_imaging":null,"contact_phone":null,"uses_services_before_completed":null,"contact_email":null,"bedded_inpatient_days_standard_care":null}}
  #{"medical_service":{"completed_at":null,
    #"bedded_inpatient_days_research":null,
    #"current_enrollment":2000,
    #"created_at":"2011-01-26T13:23:22Z",
    #"contact_name":null,
    #"expected_enrollment":3000,
    #"updated_at":"2011-01-26T13:37:53Z",
    #"expected_clinical_services":null,
    #"expects_bedded_outpatients":null,
    #"expects_bedded_inpatients":null,
    #"id":2,
    #"study_id":2343,
    #"involves_pharmacy":null,
    #"involves_labs_pathology":null,
    #"involves_imaging":null,
    #"contact_phone":null,
    #"uses_services_before_completed":null,
    #"contact_email":null,
    #"bedded_inpatient_days_standard_care":null}}
    p = {:bedded_inpatient_days_research => nil,
      :current_enrollment => 2000,
      :contact_name => nil,
      :expected_enrollment => 3000,
      :expected_clinical_services => nil,
      :expects_bedded_outpatients => nil,
      :expects_bedded_inpatients => nil,
      :involves_pharmacy => nil,
      :involves_labs_pathology => nil,
      :involves_imaging => nil,
      :contact_phone => nil,
      :uses_services_before_completed => nil,
      :contact_email => nil,
      :bedded_inpatient_days_standard_care => nil}

    t1 = MedicalService.create(p)
    t1.completed?.should be_false
  end
end

