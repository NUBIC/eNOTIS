# This model represents the affiliation a subject can have with a study.
# It holds non-temporal data only. For reporting purposes we capture gender, ethnicity, and race here
#
# For example: Disease site would be found in the Involvement join record between a subject and study.
# Disease site is a specific piece of data about why the subject is on the trial but not associated with
# a specific event. It is a long term data element that can span the whole relationship of subject and study.

require 'ruport'
class Involvement < ActiveRecord::Base

  # Constants
  # These correspond to the fields in the database for storing race
  RACE_ATTRIBUTES = {
    :race_is_american_indian_or_alaska_native          => "American Indian/Alaska Native",
    :race_is_asian                                     => "Asian",
    :race_is_black_or_african_american                 => "Black/African American",
    :race_is_native_hawaiian_or_other_pacific_islander => "Native Hawaiian/Other Pacific Islander",
    :race_is_white                                     => "White",
    :race_is_unknown_or_not_reported                   => "Unknown or Not Reported"
  }.freeze

  # Mixins
  has_paper_trail
  acts_as_reportable
	
  # Associations
  belongs_to :subject
	belongs_to :study
  has_many :involvement_events, :dependent => :destroy

  
  # Atrributes
  accepts_nested_attributes_for :involvement_events, :reject_if => lambda {|a| (a["occurred_on"].blank?) }
  accepts_nested_attributes_for :subject, :update_only=>true

  # Named scope
  default_scope :order => "case_number"
  named_scope :with_coordinator, lambda {|user_id| { 
    :include => {:study => :coordinators}, 
    :conditions => ['coordinators.user_id = ?', user_id ]}}
    
  named_scope :with_event_type, lambda {|event_type| { 
    :include => :involvement_events,
    :conditions => ['involvement_events.event_type_id = ?',event_type]}}
  
  # Validations
  validates_presence_of :gender, :ethnicity
  # Custom validator for race
  validate do |inv|
    checked = false
    RACE_ATTRIBUTES.each_key do |k|
      t = inv.send(k)
      checked ||= inv.send(k)
    end
    unless checked
      inv.errors.add_to_base("One of the race categories must be selected. If you do not know the race choose 'Unknown or Not Reported'") 
    end
  end
   
  # Public class methods 
  class << self 
    def gender_definitions 
      { "Male"                    => "A person identifying with the male sex or gender",
        "Female"                  => "A person identifying with the female sex or gender",
        "Unknown or Not Reported" => "A person not wishing to identify their gender or this person's gender is unknown" }
    end

    def translate_gender(val)
      [ /^M(ale)?$/i, "Male",
        /^F(emale)?$/i, "Female",
        /Unknown|Not Reported|^U$|^NR$/i, "Unknown or Not Reported" ].each_slice(2){|rx, term| return term if val.to_s.match(rx)}
    end
    
    def ethnicity_definitions
      { "Hispanic or Latino"      => "A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race. The term \"Spanish origin\" can also be used in addition to \"Hispanic or Latino.\"",
        "Not Hispanic or Latino"  => "A person NOT of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race.",
        "Unknown or Not Reported" => "Individuals not reporting ethnicity" }
    end

    def translate_ethnicity(val)
      [ /^Hispanic|^Latino/i, "Hispanic or Latino",
        /^Not (Hispanic|Latino)/i, "Not Hispanic or Latino",
        /Unknown|Not Reported|^U$|^NR$/i, "Unknown or Not Reported" ].each_slice(2){|rx, term| return term if val.to_s.match(rx)}
    end

    def race_definitions
      { "American Indian/Alaska Native"          => "A person having origins in any of the original peoples of North, Central, or South America, and who maintains tribal affiliations or community attachment.",
        "Asian"                                  => "A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam.",
        "Black/African American"                 => "A person having origins in any of the black racial groups of Africa.",
        "Native Hawaiian/Other Pacific Islander" => "A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.",
        "White"                                  => "A person having origins in any of the original peoples of Europe, the Middle East, or North Africa.",
        "Unknown or Not Reported"                => "A person not wishing to identify their race or this person's race is unknown" }
    end
    
    def translate_race(val)
      [ /^American Indian|^Alaskan?|^Native American/i, "American Indian/Alaska Native",
        /^Asian?$/i, "Asian",
        /^Black|^African/i, "Black/African American",
        /^(Native )?Hawaiian|Pacific Islander/i, "Native Hawaiian/Other Pacific Islander",
        /^White|^Caucasian/i, "White",
        /^Unknown|^Not Reported|^U$|^NR$/i, "Unknown or Not Reported" ].each_slice(2){|rx, term| return term if val.to_s.match(rx)}
    end
    
    # genders, ethnicities, races
    %w(gender ethnicity race).each do |category|
      define_method("#{category.pluralize}".to_sym){ self.send("#{category}_definitions").keys }
    end

    def update_or_create(params)
      if (ie = Involvement.find(:first, :conditions => {:study_id => params[:study_id], :subject_id => params[:subject_id]}))
        ie.update_attributes(params)
        ie
      else
        Involvement.create(params)
      end
    end
  end # end of class << self
  
  %w(gender ethnicity).each do |category|
    # gender=, ethnicity= (make case insensitive)
    define_method("#{category}="){|term| write_attribute(category.to_sym, self.class.send(category.pluralize).detect{|x| x.downcase == term.to_s.downcase})}
  end

  # Sets the races by accepting an array or string of race terms
  def races=(terms)
    #clearing out any previous values
    clear_all_races 
    rterms = ([] << terms).flatten # takes a string or an array and makes it into an array
    if rterms.include?("Unknown or Not Reported") # don't set any thing else
       self.race_is_unknown_or_not_reported = true
    else
      set_race_terms(rterms)
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

  def races_as_str
    races.join(", ")
  end

  def race_for_nih_report
    races.size == 1 ? races.first : "More Than One Race"
  end
  
  alias :race_as_str :races_as_str

  # A setter for the race_is_unknown_or_not_reported attribute
  # because it has to clear all other races
  # NOTE: Checking for "1" or true because rails passes the params 
    # to the set attr methods as "1"s or "0"s from the checkboxes.
    # I'm assuming there is some magic going on to set the other model
    # attributes to their boolean values from the "1"s or "0"s
  def unknown_or_not_reported_race=(val)
    if val == true || val == "1"
      clear_all_races
      self.race_is_unknown_or_not_reported = true
    elsif val == false || val == "0"
      self.race_is_unknown_or_not_reported = false
    end
  end

  # The getter so the checkbox will work
  def unknown_or_not_reported_race
    self.race_is_unknown_or_not_reported
  end

  # Used for graphs
  def short_ethnicity
    return "" if ethnicity.blank?
    (ethnicity[0..12].length == ethnicity.length) ? ethnicity : ethnicity[0..10] + "..."
  end
  
  def short_race
    return "" if race.blank?
    return "multiple" if races.size > 1
    (races.first[0..12].length == races.first.length) ? races.first : races.first[0..10] + "..."
  end
  
  def short_gender
    return "" if gender.blank?
    (gender[0..12].length == gender.length) ? gender : gender[0..10] + "..."
  end
  # END of methods used for graphs

  def all_events
    # A placeholder method to get an easy checkbox? 
    # Not sure why this is here but it's "method" 
    # used when generating reports. Basically used as
    # a flag, this method is never actually called
    # as far as I can tell. - BLC
  end

  %w(consented withdrawn completed).each  do |name|
    define_method("#{name}_report".to_sym) do
       ev = self.send(:event_detect, name)
       ev.occurred_on if ev
    end
    define_method(name.to_sym) do
      self.send(:event_detect, name)
    end
  end

  def completed_or_withdrawn
    completed || withdrawn
  end

  def event_detect(ev_name)
    ev_type = self.study.event_types.find_by_name(ev_name)
    involvement_events.find(:first, :conditions => {:event_type_id => ev_type.id}) if ev_type
  end

  def subject_name_or_case_number
    subject.name.blank? ? case_number : subject.name
  end

  def single_line_ie_export
    involvement_events.collect{ |ev| "#{ev.event_type.name} -- #{ev.occurred_on}" }.join("\n")
  end

  def subject_name
    subject.name
  end

  def first_name
    subject.first_name
  end

  def last_name
    subject.last_name
  end

  def nmff_mrn
    subject.nmff_mrn
  end

  def nmh_mrn
    subject.nmh_mrn
  end

  def ric_mrn
    subject.ric_mrn
  end


  # TODO: learn how to mock this for testing
  def after_save
    unless self.study.read_only?
      begin
        Resque.enqueue(EmpiWorker, self.id) 
      rescue Errno::ECONNREFUSED => e
        logger.debug("the EMPI would process involvement #{self.id} if resque was running")
      end
    end
  end
  
  private
  def set_race_terms(rterms)
    rterms.map(&:downcase).each do |term|
      by_term = {}
      RACE_ATTRIBUTES.each{|k,v| by_term[v.downcase] = k} # Doing this because the conts is frozen
      by_term.each_key {|k| k.downcase} #downcasing the term strings 
      if by_term.keys.include?(term)
        send("#{by_term[term]}=",true) #setting the db attr for the race term passed in
      end
    end
  end

  def clear_all_races # includes the :race_is_unknown_or_not_reported "race"
    RACE_ATTRIBUTES.each_key{|ra| send("#{ra}=", false)}    
  end
  
end
