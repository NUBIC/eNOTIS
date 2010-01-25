class Coordinator < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  # Mixins
  has_paper_trail
 
  # Validators
  validates_uniqueness_of :user_id, :scope => :study_id
  
end
