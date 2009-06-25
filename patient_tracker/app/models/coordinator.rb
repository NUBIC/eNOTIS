class Coordinator < ActiveRecord::Base
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :netid, :to => :user
  has_paper_trail
end
