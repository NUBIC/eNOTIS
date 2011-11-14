class SurveyGroup < ActiveRecord::Base

  has_many :surveys

  validates_uniqueness_of :access_code

  def next(response_set)
    next_response = nil
    if self.progression.eql?('random')
      unanswered_surveys = active_unanswered_surveys(response_set.involvement)
      next_response =  ResponseSet.create(:involvement=>response_set.involvement,:survey=>unanswered_surveys.rand,:effective_date=>response_set.effective_date) unless unanswered_surveys.empty?
    elsif self.progression.eql?('sequential')
      next_survey = next_sequential_active_survey_following(response_set.survey)
      next_response =  ResponseSet.create(:involvement=>response_set.involvement,:survey=>next_survey,:effective_date=>response_set.effective_date) unless next_survey.nil?
    end
    return next_response
  end

  def access_code=(value)
    super(Survey.to_normalized_string(value))
  end
  
  def active_unanswered_surveys(involvement)
    answered_surveys = involvement.response_sets.collect{|r| r.survey}
    surveys.reject{|s| !s.active? || answered_surveys.include?(s)}
  end
  
  def next_sequential_active_survey_following(survey)
    surveys.reject{|s| !s.active? || s.display_order <= survey.display_order}.sort_by{|s| s.display_order}.first
  end
end
