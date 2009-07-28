# This model represents the affiliation a subject can have with a study.
# It holds non-temporal data only. For reporting purposes we capture gender, ethnicity, and race here
#
# For example: Disease site would be found in the Involvement join record between a subject and study.
# Disease site is a specific piece of data about why the subject is on the trial but not associated with
# a specific event. It is a long term data element that can span the whole relationship of subject and study.

class Involvement < ActiveRecord::Base
	
  # Associations
  belongs_to :subject
	belongs_to :study
  has_many :involvement_events
  has_one :gender_type, :class_name => "DictionaryTerm"
  has_one :ethnicity_type, :class_name => "DictionaryTerm"
  has_many :races

  # Mixins
  has_paper_trail

  # Validations
  validates_presence_of :gender_type_id, :ethnicity_type_id
  
  # Public instance methods
  
  # Races are additive - this method finds the new race_type_ids and creates an associated race for each one
  def race_type_ids=(race_type_ids)
    new_races = race_type_ids - self.races.map(&:race_type_id)
    new_races.each{|race_type_id| self.races.build(:race_type_id => race_type_id)}
  end
  
  # Public class methods
  def self.update_or_create(params)
    if (ie = Involvement.find(:first, :conditions => {:study_id => [:study_id], :subject_id => params[:subject_id]}))
      ie.update_attribute(params)
    else
      Involvement.create(params)
    end
  end
end