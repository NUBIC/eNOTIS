class StudyTable < ActiveRecord::Base
  has_many :roles, :foreign_key => "study_id"
  belongs_to :study, :foreign_key => "id"
  named_scope :paged, lambda {|start, limit| { :offset => start ,:limit => limit}}
  named_scope :order, lambda {|order| { :order => order}}
  delegate :may_accrue?, :has_coordinator? , :approved_date, :expiration_date, :closed_or_completed_date, :research_type, :funding_sources, :to => :study
  
end