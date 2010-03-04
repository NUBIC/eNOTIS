# This model represents the affiliation a subject can have with a study.
# It holds non-temporal data only. For reporting purposes we capture gender, ethnicity, and race here
#
# For example: Disease site would be found in the Involvement join record between a subject and study.
# Disease site is a specific piece of data about why the subject is on the trial but not associated with
# a specific event. It is a long term data element that can span the whole relationship of subject and study.
#require 'ruport'
require 'ruport'
class Involvement < ActiveRecord::Base

  
  acts_as_reportable
	
  # Associations
  belongs_to :subject
	belongs_to :study
  has_many :involvement_events
  belongs_to :gender_type, :class_name => "DictionaryTerm", :foreign_key => :gender_type_id
  belongs_to :ethnicity_type, :class_name => "DictionaryTerm", :foreign_key => :ethnicity_type_id
  has_many :races
  
  # Named scope
  named_scope :with_coordinator, lambda {|user_id| { :include => {:study => :coordinators}, :conditions => ['coordinators.user_id = ?', user_id ]}}

  # Mixins
  has_paper_trail
  # Validations
  validates_presence_of :gender_type_id, :ethnicity_type_id

  # Public instance methods
  
  def consented
    involvement_events.detect{|e| e.event_type_id == DictionaryTerm.event_id("Consented")}
  end
  def completed
    involvement_events.detect{|e| e.event_type_id == DictionaryTerm.event_id("Completed") or e.event_type_id == DictionaryTerm.event_id("Withdrawn")}
  end
  # Races are additive - this method finds the new race_type_ids and creates an associated race for each one
  def race_type_ids=(race_type_ids)
    race_type_ids = race_type_ids.map{|i| i.is_a?(Hash) ? i.keys : i}.flatten.map(&:to_i)
    new_races = race_type_ids - self.races.map(&:race_type_id)
    new_races.each{|race_type_id| self.races.build(:race_type_id => race_type_id)}
  end
  
  def race_type_ids
    races.map(&:race_type_id)
  end
  def ethnicity
    self.ethnicity_type ? self.ethnicity_type.term : nil
  end
  def short_ethnicity
    return "" unless self.ethnicity_type
    term = self.ethnicity_type.term
    (term[0..12].length == term.length) ? term : term[0..10] + "&#0133;"
  end

  def gender
    self.gender_type ? self.gender_type.term : nil
  end

  def race_list
    self.races.map{|race| race.race_type.term}.join(";")
  end
  
  def subject_name_or_case_number
    subject.name.blank? ? case_number : subject.name
  end
  # Public class methods
  def self.update_or_create(params)
    if (ie = Involvement.find(:first, :conditions => {:study_id => params[:study_id], :subject_id => params[:subject_id]}))
      ie.update_attributes(params)
      ie
    else
      Involvement.create(params)
    end
  end
  
end






