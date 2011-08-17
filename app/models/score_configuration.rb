class ScoreConfiguration < ActiveRecord::Base
  belongs_to :survey
  has_many :scores
   

end
