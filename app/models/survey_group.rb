class SurveyGroup < ActiveRecord::Base

  has_many :surveys

  validates_uniqueness_of :access_code

  def next(response_set)
    next_response = nil
    if self.progression.eql?('random')
      remaining = surveys.reject{|s| response_set.involvement.response_sets.collect{|r| r.survey}.include?(s)}
      next_response =  ResponseSet.create(:involvement=>response_set.involvement,:survey=>remaining.rand,:effective_date=>response_set.effective_date) unless remaining.empty?
    elsif self.progression.eql?('sequential')      
      survey = surveys.find_by_display_order(response_set.survey.display_order +1)
      next_response =  ResponseSet.create(:involvement=>response_set.involvement,:survey=>survey,:effective_date=>response_set.effective_date) unless survey.nil
    end
    return next_response
  end

  def access_code=(value)
    super(Survey.to_normalized_string(value))
  end

end
