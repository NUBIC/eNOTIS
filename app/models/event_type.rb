# Holds event types defined by the study
class EventType < ActiveRecord::Base
  has_many :involvement_events
  belongs_to :study

  before_destroy :delete_validator

  validates_uniqueness_of :name, :scope => :study_id, :case_sensitive => false
 
  attr_protected :editable # Hiding the editable flag from mass assignment


 # Default events are created per study when a new study 
 # is created. Once attached to a study they can be edited by 
 # study team.
 # The seq number is for display purposes only

 DEFAULT_EVENTS = {
     # Pre-screened will be the Registar default loading state for a participant.
     "Pre-screened" => {
       :name => "Pre-screened",
       :description => "The participant fits the general criteria for the study. Meets inclusion/exclusion critera",
       :seq => 1,
       :editable => false},

     "Consented" => {
       :name => "Consented", 
       :description => "The participant has signed informed consent form",
       :seq => 2,
       :editable => false},

     "Screening" => {
       :name => "Screening",
       :description => "The participant is in the screening process",
       :time_span => :period,
       :seq => 3},

     "On Study" => {
       :name => "On Study",
       :description => "The participant has passed screening and is enrolled on the study",
       :time_span => :period,
       :seq => 4},

     "Randomized" => {
       :name => "Randomized",
       :description => "The participant has been assigned to a study arm/drug",
       :seq => 5},

     "Completed" => {
       :name => "Completed",
       :description => "The participant has completed all aspects of the study, including active monitoring or follow-up",
       :seq => 6,
       :editable => false},

     "Follow-Up" => {
       :name => "Follow-Up",
       :description => "The participant has completed the treatment phase of the study and is no longer receiving treatment but is being followed or monitored",
       :time_span => :period,
       :seq => 7},

     "Withdrawn" => {
       :name => "Withdrawn", 
       :description => "The participant has withdrawn from the study on their own accord",
       :seq => 8, 
       :editable => false},

     "Failed (study adherence)" => {
       :name => "Failed (study adherence)",
       :description => "The participant is no longer eligible for this study or is non-compliant with the study requirements",
       :seq => 9,
       :editable => false},

     "Screen Fail" => {
       :name => "Screen Fail",
       :description => "The participant has failed to meet screening requirements",
       :seq => 10,
       :editable => false},

     "Lost to Follow-Up" => {
       :name => "Lost to Follow-Up",
       :description => "The participant was in follow-up but can no longer be reached. Status is unknown",
       :seq => 11,
       :editable => false},

     "Death" => {
       :name => "Death",
       :description => "The participant has died. Please indicate reason in notes. Common reasons: Protocol Disease, Protocol Treatment, Unrelated to Protocol (elaborate in notes), Unknown",
       :seq => 12,
       :editable => false}

 }

  
  # Determine which events we want to use to add to or remove from 
  # current enrollment totals
  ENROLLMENT_INCR = ["Consented"]
  ENROLLMENT_DECR = ["Failed","Completed","Withdrawn"]

  # A class method to help with formatting the name of the
  # event to have a consistent presentation
  def self.event_name_formatter(in_str)
    str = in_str.strip # removing starting and ending whitespace
    str.downcase! # setting all to lowercase
    str.squeeze!(' ') # removing redundant ws
    s_str = str.split(' ') # spliting on ws
    s_str.each{|w| w.capitalize!}
    s_str.join(' ')
  end

  # Forcing all assignment of the name attribute through our formatter 
  def name=(new_name)
    write_attribute(:name, EventType.event_name_formatter(new_name))
  end

  # Checks to see if the event is linked to any
  # involvement events. 
  def is_used?
    !self.involvement_events.empty?
  end

  %w(repeatable editable).each do |m_name|
    define_method("#{m_name}?".to_sym) do
      self.send(m_name)
    end
  end

  # Prevents deletion if there are events that use this
  def delete_validator
    if is_used?
      self.errors.add "This event is used on participant records. You must remove all participant events before deleteing this event type"
      false
    end
  end

  # determines if the current type should add to
  # or subtract from the study enrollment count
  def enrollment_adjustment
    if ENROLLMENT_INCR.include?(self.name)
      1
    elsif ENROLLMENT_DECR.include?(self.name)
      -1 
    else
      0
    end
  end
end
