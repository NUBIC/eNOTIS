class SurveyGroup < ActiveRecord::Base

  has_many :surveys

  validates_uniqueness_of :access_code

  def next(response_set)
    next_response = nil
    if self.progression.eql?('random')
      remaining = surveys.reject{|s| response_set.involvement.response_sets.collect{|r| r.survey}.include?(s)}
      next_response =  ResponseSet.create(:involvement=>response_set.involvement,:survey=>remaining.rand) unless remaining.empty?
    elsif self.progression.eql?('sequential')
      
    end
    return next_response
  end

  def access_code=(value)
    super(Survey.to_normalized_string(value))
  end

end
