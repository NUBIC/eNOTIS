class SurveyGroup < ActiveRecord::Base

  has_many :surveys

  validates_uniqueness_of :access_code

  def next(response_set)
    case progression
    when 'random'
      next_survey = active_unanswered_surveys(response_set.involvement).rand
    when 'sequential'
      next_survey = next_sequential_active_survey_following(response_set.survey)
    end
    
    next_survey.nil? ? nil : ResponseSet.create(:involvement=>response_set.involvement,:survey=>next_survey,:effective_date=>response_set.effective_date)
  end

  def access_code=(value)
    super(Survey.to_normalized_string(value))
  end
  
  def active_unanswered_surveys(involvement)
    surveys.reject{|s| !s.active? || involvement.surveys.include?(s)}
  end
  
  def next_sequential_active_survey_following(survey)
    surveys.reject{|s| !s.active? || s.display_order <= survey.display_order}.sort_by{|s| s.display_order}.first
  end
end
