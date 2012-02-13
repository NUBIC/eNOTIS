require 'spec_helper'

describe ResponseSet do
  before(:each) do
  end

  it "should not complete a survey that doesn't have it's mandatory sections complete" do 
    `rake surveyor FILE=spec/surveys/response_set/simple.rb`
    survey = Survey.find_by_title("simple")
    response_set = ResponseSet.create(:survey=>survey)
    response_set.complete_with_validation!.should == false
    response_set.completed_at.should be nil
  end

  it "should complete a survey that has all responses complete" do 
    survey = Survey.find_by_title("simple")
    response_set = ResponseSet.create(:survey=>survey)
    questions = survey.sections.first.questions
    questions.each{|q| Response.create(:response_set_id=>response_set.id,:question=>q,:answer=>q.answers.first)}
    response_set = ResponseSet.find(response_set.id)
    response_set.mandatory_questions_complete?.should == true
    response_set.complete_with_validation!.should == true
  end
  it "should accept json responses from gi diaries" do
    `rake surveyor FILE=surveys/STU00039540/gi_diaries.rb`
    params = [{"started_at"=>"2012-02-08 09:00:00", "antacids"=>"0", "symptoms"=>"none", "severity"=>"", "completed_at"=>"2012-02-08 09:01:01", "survey"=>"morning", "sleep"=>""}, {"started_at"=>"2012-02-08 21:00:00", "antacids"=>"0", "symptoms"=>"none", "severity"=>"", "completed_at"=>"2012-02-08 21:01:01", "survey"=>"evening"}]
    survey = Survey.find_by_title("GI Diaries")
    response_set = ResponseSet.create(:survey => survey)
    response_set.gi_responses = params
    response_set.should have(4).responses
  end
end