class Score < ActiveRecord::Base
  belongs_to :score_configuration
  belongs_to :response_set
   

  validates_presence_of :value
  validates_uniqueness_of :response_set_id, :scope => :score_configuration_id

end
