require 'scoring/algorithms'
include Algorithms
class Scoring
  def self.score(response_set)
    survey = response_set.survey
    survey.score_configurations.each do |configuration|
      value = Algorithms.send configuration.algorithm.to_sym, response_set, configuration.question_code
      response_set.scores.create(:score_configuration => configuration, :value=>value)  unless value.blank?
    end
  end
end
