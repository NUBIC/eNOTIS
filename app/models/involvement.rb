# This model represents the affiliation a subject can have with a study.
# It holds non-temporal data only. For reporting purposes we capture gender, ethnicity, and race here
#
# For example: Disease site would be found in the Involvement join record between a subject and study.
# Disease site is a specific piece of data about why the subject is on the trial but not associated with
# a specific event. It is a long term data element that can span the whole relationship of subject and study.

require 'ruport'
class Involvement < ActiveRecord::Base
  acts_as_reportable
	
  # Associations
  belongs_to :subject
	belongs_to :study
  has_many :involvement_events
  
  # Atrributes
  accepts_nested_attributes_for :involvement_events, :reject_if => lambda {|a| (a["occurred_on"].blank? or a["event"].blank?) }
  accepts_nested_attributes_for :subject
  
  # Named scope
  named_scope :with_coordinator, lambda {|user_id| { :include => {:study => :coordinators}, :conditions => ['coordinators.user_id = ?', user_id ]}}

  # Mixins
  has_paper_trail
  
  # Validations
  validates_presence_of :gender, :ethnicity

  # Constants
  # These correspond to the fields in the database for storing race
  RACE_ATTRIBUTES = {
    :is_american_indian_or_alaska_native => "American Indian/Alaska Native",
    :is_asian => "Asian",
    :is_black_or_african_american => "Black/African American",
    :is_native_hawaiian_or_other_pacific_islander => "Native Hawaiian/Other Pacific Islander",
    :is_white => "White",
    :is_unknown_or_not_reported => "Unknown or Not Reported"}.freeze

  
  # Public class methods 
  class << self 
    def gender_definitions 
      [ ["Male",                     "A person identifying with the male sex or gender"],
        ["Female",                   "A person identifying with the female sex or gender"],
        ["Unknown or Not Reported",  "A person not wishing to identify their gender or this person's gender is unknown"] ]
    end

    def ethnicity_definitions
      [ ["Hispanic or Latino",      "A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race. The term \"Spanish origin\" can also be used in addition to \"Hispanic or Latino.\""],
        ["Not Hispanic or Latino",  "A person NOT of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race."],
        ["Unknown or Not Reported",                 "Individuals not reporting ethnicity"] ]
    end
  
    def race_definitions
      [ ["American Indian/Alaska Native",          "A person having origins in any of the original peoples of North, Central, or South America, and who maintains tribal affiliations or community attachment."],
        ["Asian",                                  "A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam."],
        ["Black/African American",                 "A person having origins in any of the black racial groups of Africa."],
        ["Native Hawaiian/Other Pacific Islander", "A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands."],
        ["White",                                  "A person having origins in any of the original peoples of Europe, the Middle East, or North Africa."],
        ["Unknown or Not Reported",                "A person not wishing to identify their race or this person's race is unknown"] ]
    end
    
    %w(gender ethnicity race).each do |category|
      # genders, ethnicities, race
      define_method("#{category.pluralize}".to_sym){ self.send("#{category}_definitions").transpose[0] }
      # define_gender, define_ethnicity, define_race
      define_method("define_#{category}".to_sym){|term| (self.send("#{category}_definitions").detect{|t,d| t == term} || [])[1] }
    end

    def update_or_create(params)
      if (ie = Involvement.find(:first, :conditions => {:study_id => params[:study_id], :subject_id => params[:subject_id]}))
        ie.update_attributes(params)
        ie
      else
        Involvement.create(params)
      end
    end

  end # end of << class
  
  %w(gender ethnicity).each do |category|
    # gender=, ethnicity= (make case insensitive)
    define_method("#{category}="){|term| write_attribute(category.to_sym, self.class.send(category.pluralize).detect{|x| x.downcase == term.to_s.downcase})}
  end

  # Sets the races by accepting an array or string of race terms
  def races=(terms)
    #clearing out any previous values
    RACE_ATTRIBUTES.each_key{|ra| send("#{ra}=", false)}

    rterms = ([] << terms).flatten # takes a string or an array and makes it into an array
    rterms.map(&:downcase).each do |term|
      by_term = {}
      RACE_ATTRIBUTES.each{|k,v| by_term[v.downcase] = k} # Doing this because the conts is frozen
      by_term.each_key {|k| k.downcase} #downcasing the term strings 
      if by_term.keys.include?(term)
        send("#{by_term[term]}=",true) #setting the db attr for the race term passed in
      end
    end
  end

  # Returns the races as the defined strings. Pulled out of the attribute fields
  def races
    race_array = []
    RACE_ATTRIBUTES.each_key do |k|
      if send(k) == true
        race_array << RACE_ATTRIBUTES[k]
      end
    end
    race_array.sort
  end
  
  alias :race :races
  alias :race= :races=

  # Used for graphs
  def short_ethnicity
    return "" if ethnicity.blank?
    (ethnicity[0..12].length == ethnicity.length) ? ethnicity : ethnicity[0..10] + "&#0133;"
  end
  
  def short_race
    return "" if race.blank?
    return "multiple" if races.size > 1
    (races.first[0..12].length == races.first.length) ? races.first : races.first[0..10] + "&#0133;"
  end
  
  def short_gender
    return "" if gender.blank?
    (gender[0..12].length == gender.length) ? gender : gender[0..10] + "&#0133;"
  end
  # END of methods used for graphs

  def consented
    involvement_events.detect{|e| e.event == "Consented"}
  end                                    

  # Why a method named "completed" when it also handles the "withdrawn" case? - BLC
  def completed                          
    involvement_events.detect{|e| e.event == "Completed" or e.event == "Withdrawn"}
  end
 
  def subject_name_or_case_number
    subject.name.blank? ? case_number : subject.name
  end
  
end
