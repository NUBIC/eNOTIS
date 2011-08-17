require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'lib/scoring'

describe Scoring do 
 
  it "should properly score records using the Partial Sum algorithm" do 
    `rake surveyor FILE=spec/surveys/lib/scoring/simple_sum.rb`
    survey = Survey.find_by_title("simple_sum")
    survey.score_configurations.create(:name => "Simple Sum",:algorithm=>"partial_sum",:question_code=>'simple_sum')
    questions = survey.sections.collect{|s| s.questions}.flatten
    answers = questions.collect{|q| q.answers.find_by_text('Yes')}
    response_set =ResponseSet.create(:survey_id=>survey.id)
    answers.each{|a| response_set.responses.create(:question_id=>a.question.id,:answer_id=>a.id)}
    Scoring.score(response_set)
    response_set.scores.size.should==1
    response_set.scores.first.value.should == 2
  end

  it "should sum all fields in response_set if algorithm is total_sum" do 
    `rake surveyor FILE=spec/surveys/lib/scoring/simple_sum.rb`
    survey = Survey.find_by_title("simple_sum")
    survey.score_configurations.create(:name => "Simple Sum",:algorithm=>"total_sum")
    questions = survey.sections.collect{|s| s.questions}.flatten
    answers = questions.collect{|q| q.answers.find_by_text('Yes')}
    response_set =ResponseSet.create(:survey_id=>survey.id)
    answers.each{|a| response_set.responses.create(:question_id=>a.question.id,:answer_id=>a.id)}
    response_set = ResponseSet.find(response_set.id)
    response_set.complete_with_validation!
    response_set.scores.first.value.should == 4
  end

  it "should not score response_set if questions are not complete" do 
    `rake surveyor FILE=spec/surveys/lib/scoring/simple_sum.rb`
    survey = Survey.find_by_title("simple_sum")
    survey.score_configurations.create(:name => "Simple Sum",:algorithm=>"partial_sum",:question_code=>'simple_sum')
    questions = survey.sections.collect{|s| s.questions}.flatten
    answers = questions.collect{|q| q.answers.find_by_text('Yes')}
    response_set =ResponseSet.create(:survey_id=>survey.id)
    answers.each{|a| response_set.responses.create(:question_id=>a.question.id,:answer_id=>a.id)}
    response_set.responses.first.delete
    response_set = ResponseSet.find(response_set.id)
    response_set.complete_with_validation!
    response_set.scores.size.should ==0
  end

  it "should score multiple algorithms correctly"  do 
    `rake surveyor FILE=spec/surveys/lib/scoring/simple_sum.rb`
    survey = Survey.find_by_title("simple_sum")
    conf1 = survey.score_configurations.create(:name => "Simple Sum",:algorithm=>"partial_sum",:question_code=>'simple_sum')
    conf2 = survey.score_configurations.create(:name => "Simple Sum2",:algorithm=>"partial_sum",:question_code=>'simple_sum2')
    conf3 = survey.score_configurations.create(:name => "Simple Sum2",:algorithm=>"total_sum",:question_code=>'simple_sum2')
    questions = survey.sections.collect{|s| s.questions}.flatten
    answers = questions.collect{|q| q.answers.find_by_text('Yes')}
    response_set =ResponseSet.create(:survey_id=>survey.id)
    answers.each{|a| response_set.responses.create(:question_id=>a.question.id,:answer_id=>a.id)}
    response_set.responses.first.delete
    response_set.complete_with_validation!
    response_set.scores.size.should == 3
    response_set.scores.find_by_score_configuration_id(conf1.id).value.should == 2
    response_set.scores.find_by_score_configuration_id(conf2.id).value.should == 2
    response_set.scores.find_by_score_configuration_id(conf3.id).value.should == 4
  end

end

