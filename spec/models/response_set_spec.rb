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
 
end
