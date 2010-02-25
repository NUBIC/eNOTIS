class Coordinator < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  # Mixins
  # has_paper_trail <-- commented out because the data that populates this model is from eIRB. We don't need to track the versions -BLC 02/16/10
 
  # Validators
  validates_uniqueness_of :user_id, :scope => :study_id

end
