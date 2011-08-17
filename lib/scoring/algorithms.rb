module Algorithms
  def partial_sum(response_set,score_code)
    survey = response_set.survey
    questions = survey.sections.collect{|s| s.questions.select{|q| q.score_code==score_code}}.flatten
    return sum(questions,response_set)
  end
  def total_sum(response_set,score_code=nil)
    sum = 0
    response_set.responses.each{|r| sum += r.answer.weight unless r.answer.weight.blank?}
    return sum
  end

  #def shoulder_score_index(response_set,score_code=nil)
  #  survey = response_set.survey
  #  questions = survey.sections.collect{|s| s.questions}.flatten
  #  adl_score = sum(questions.select{|q| q.score_code=="adl"},response_set)
  #  vas_pain_score = response_set.responses.detect{|r| r.question.score_code=="vas_pain"}.answer.weight
  #  ((10 - vas_pain_score) *5) + ((5/3.0) * adl_score)
  #end

  private
  def sum(questions,response_set)
    sum = 0
    responses = response_set.responses.select{|r| questions.collect{|q| q.id }.include?(r.question_id)}
    responses.each{|r| sum +=r.answer.weight unless r.answer.nil? || r.answer.weight.nil? }
    return sum
  end

end
