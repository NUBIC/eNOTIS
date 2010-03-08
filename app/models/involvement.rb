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
  
  # Atrributes
  accepts_nested_attributes_for :involvement_events, :reject_if => lambda {|a| a["occurred_on"].blank? or a["event"].blank? }
  accepts_nested_attributes_for :subject
  
  # Named scope
  named_scope :with_coordinator, lambda {|user_id| { :include => {:study => :coordinators}, :conditions => ['coordinators.user_id = ?', user_id ]}}

  # Mixins
  has_paper_trail
  
  # Validations
  validates_presence_of :gender, :ethnicity, :race
  
  # Public class methods
  
  class << self 
    def gender_definitions 
      [ ["Male",                     "A person identifying with the male sex or gender"],
        ["Female",                   "A person identifying with the female sex or gender"],
        ["Unknown or Not Reported",  ""] ]
    end

    def ethnicity_definitions
      [ ["Hispanic or Latino",      "A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race. The term \"Spanish origin\" can also be used in addition to \"Hispanic or Latino.\""],
        ["Not Hispanic or Latino",  "A person NOT of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race."],
        ["Unknown",                 "Individuals not reporting ethnicity"] ]
    end
    def race_definitions
      [ ["American Indian/Alaska Native",          "A person having origins in any of the original peoples of North, Central, or South America, and who maintains tribal affiliations or community attachment."],
        ["Asian",                                  "A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam."],
        ["Black/African American",                 "A person having origins in any of the black racial groups of Africa."],
        ["Native Hawaiian/Other Pacific Islander", "A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands."],
        ["White",                                  "A person having origins in any of the original peoples of Europe, the Middle East, or North Africa."],
        ["More than one race",                     ""],
        ["Unknown or Not Reported",                ""] ]
    end
    %w(gender ethnicity race).each do |category|
      # genders, ethnicities, races
      define_method("#{category.pluralize}".to_sym){ self.send("#{category}_definitions").transpose[0] }
      # define_gender, define_ethnicity, define_race
      define_method("define_#{category}".to_sym){|term| (self.send("#{category}_definitions").detect{|t,d| t == term} || [])[1] } 
    end
  end
  def short_ethnicity
    return "" if ethnicity.blank?
    (ethnicity[0..12].length == ethnicity.length) ? ethnicity : ethnicity[0..10] + "&#0133;"
  end
  def short_race
    return "" if race.blank?
    (race[0..12].length == race.length) ? race : race[0..10] + "&#0133;"
  end
  def short_gender
    return "" if gender.blank?
    (gender[0..12].length == gender.length) ? gender : gender[0..10] + "&#0133;"
  end

  # Public instance methods
  def consented
    involvement_events.detect{|e| e.event == "Consented"}
  end                                    
  def completed                          
    involvement_events.detect{|e| e.event == "Completed" or e.event == "Withdrawn"}
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






