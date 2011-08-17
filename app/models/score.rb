class Score < ActiveRecord::Base
  belongs_to :score_configuration
  belongs_to :response_set
   

  validates_presence_of :value


end
