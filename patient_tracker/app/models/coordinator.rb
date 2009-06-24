class Coordinator < ActiveRecord::Base
  belongs_to :user
  belongs_to :study
  has_paper_trail
end
