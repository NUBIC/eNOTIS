require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../soap_mock_helper')
require 'eirb_services'

describe EirbServices do
  
  describe "search results" do
    before(:each) do
      @service = EirbServices::EirbService.new
    end

    it "can find the status of a study by id" do
      @service.find_status_by_id("STU123123123").should == []
      @service.find_status_by_id("STU00000706").should == [{"ID" => "STU00000706", "Project State.ID" => "Approved"} ]
    end

    # TODO This is a very fragile test and needs to be replaced
    it "can find the details of a study by id" do 
      @service.find_study_by_id("STU00000706").should == [{"Name"=>"A randomized, rater-blinded, split-face comparison of the efficacy of Intense Pulse Light vs. Q-switched Nd:Yag laser for the treatment of melasma.", "Study Title"=>"A randomized, rater-blinded, split-face comparison of the efficacy of Intense Pulse Light vs. Q-switched Nd:Yag laser for the treatment of melasma.", "Project State.ID"=>"Approved", "ID"=>"STU00000706", "Activated Date"=>"1/1/1800 2:00:00 AM", "Type"=>"_Protocol", "Research Type.Name"=>"Bio-medical", "Description"=>"Melasma is a common acquired condition of circumscribed hyperpigmentation that is usually progressive and lasts for many years and is difficult to treat. This study will further evaluate the Q-switched Nd: YAG laser operating at 1064 nm in comparison to intense pulse light in the treatment of melasma lesions. To adequately assess this laser treatment, it will be compared to intense pulsed light. IPL will be used to comparatively evaluate the efficacy of laser treatment because it has shown promise in treating melasma . This study is a randomized, double-blind, single-center prospective clinical study of 20 subjects. Participants in this study will be patients at the dermatology clinic who are clinically diagnosed with melasma. One half of the subject’s face will be assigned to receive a total of 3 treatments of Q-switched Nd:Yag laser and the other half of the face will be assigned to receive a total of 3 treatments 0f IPL. The treatment will be conducted at each of weeks 0, 5, and 10 (ie, one treatment on each visit). There will be a follow up visit at 15 weeks to asses the treatment efficacy. Baseline digital photography will be taken at each of these visits. The clinician will assess the subject’s melasma using the Melasma Area and Severity Index (MASI) at the baseline visit and at the 15 weeks follow up visit. The subject will also be asked to complete the Melasma Quality of Life questionnaire (MELASQOL) at these visits."}]
    end
      
  end
end
