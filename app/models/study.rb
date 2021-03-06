require 'chronic'
require 'webservices/importer'
# Represents a Clinical Study/Trial.
class Study < ActiveRecord::Base

  # Some semi-static data about the external systems we get data from
  EXT_DATA = {
    'NOTIS' => {:name => "NOTIS"},
    'EIRB' => {:name => "eIRB"},
    'ANES' => {:name => "Anesthesiology"},
    'REGISTAR' => {:name => "Registar"}
  }
 
  include Webservices::ImporterSupport

  before_save :flatten_import_cache
   
  # Named scopes
  # this named scope allows sorting by "accrual", which is a count of involvements.
  # %w(id irb_status irb_number name title accrual_goal) can be replaced with Study.column_names if needed, but it is slow
  named_scope :order_by, lambda {|order, direction| order != "accrual" ? {:order => "#{order} #{direction.upcase}"} : 
    { :joins => :involvements, 
      :select => %w(id irb_status irb_number name title accrual_goal).map{|c| "studies.#{c}"}.join(", ") + ", COUNT(*) as accrual", 
      :group => %w(id irb_status irb_number name title accrual_goal).map{|c| "studies.#{c}"}.join(", "), 
      :order => "accrual #{direction.upcase}"}}
  named_scope :with_user, lambda{|netid| {:include => :roles, :conditions => ["roles.netid =?", netid]}}
  STATUS_TO_EXCLUDE = [ "Withdrawn", "Rejected", "Exempt Review: Changes Requested",
      "Original Version", "In Expedited Review", "Expired", "Expedited Review: Changes Requested",
      "Expedited Review: Awaiting Correspondence", "Exempt Review: Changes Requested",
      "Exempt Approved","Closed/Terminated", "Pre Submission"]
  
  named_scope :open_studies, :conditions => "closed_or_completed_date is null and irb_status not in (#{STATUS_TO_EXCLUDE.map{|r| "'#{r}'"}.join(',')})"
  named_scope :has_medical_services, :conditions => "uses_medical_services = true"

  # Associations
  has_many :involvements
  has_many :roles, :dependent => :delete_all
  has_many :subjects, :through => :involvements
  has_many :involvement_events, :through => :involvements
  has_many :study_uploads
  has_many :funding_sources, :dependent => :delete_all
  has_many :surveys
  has_one  :medical_service, :dependent => :delete
  has_many :event_types, :order => "seq asc" do 
    def find_by_name(e_name)
      find(:first, :conditions => {:name =>EventType.event_name_formatter(e_name)})
    end

    def define_event(e_name)
      ev = find_by_name(e_name)
      (ev.nil?) ? nil : ev.description
    end
  end
  
  # Callbacks
  after_create :create_default_events

  # Validators
  validates_format_of :irb_number, :with => /^STU.+/, :message => "invalid study number format"
 
  # Class methods

  # This method should be called 
  # when importing from a webservice or other external source
  def self.import_update(study, bulk_data)
    if bulk_data[:funding_sources]
      bulk_data[:funding_sources].each do |fs| 
        unless study.funding_sources.find(:first, :conditions => fs)
          study.funding_sources.create(fs)
        end
      end
      to_delete = []
      study.funding_sources.each do |fs|
        # must be an exact matach of the elements... 
        # There are some funding sources with no code, and each of those source names are different. YAY eIRB!!
        unless bulk_data[:funding_sources].include?({:name => fs.name, :code => fs.code, :category => fs.category})
          to_delete << fs
        end
      end
      #deleting ones not in the new hash 
      study.funding_sources.delete(to_delete)
      bulk_data.delete(:funding_sources)
    end
    study.update_attributes(bulk_data)
  end
  

  # ======= study data management notes ========
  # All key study data comes from eIRB!
  # BUT! we make a distinction for the study subjects/paraticipants.
  # These can come from different systems (and are pull throught the EDW)
  # When an other system feeds participant data to a study in eNOTIS
  # we consider this study to be externally managed. Managed studies
  # need additional webservice calls to import data (ie the subjects).

  # This method is used to toggle the editable/non-editable state of 
  # patients and patient data (ie involvments, involvment_events, subjects).
  def read_only!(msg = nil)
    self.read_only = true
    self.read_only_msg = msg
  end

  # This method reverts a study to read/editable
  def editable!
    self.read_only = false
    self.read_only_msg = nil
  end

  # Returns the read status of the study
  def read_only?
    self.read_only
  end

  # Returns the edit status of the study
  def editable?
    !self.read_only
  end

  # This method sets the system name (it can only be one) and 
  # sets the study to read-only so users cannot add/edit subjects through 
  # the eNOTIS UI.
  def managed_by(sys_name)
    sys_hash = EXT_DATA[sys_name]
    if sys_hash
      msg = "This study is managed by the #{sys_hash[:name]} system."
      self.read_only!(msg)
      self.managing_system = sys_name
    end
  end

  def is_managed?
    !managing_system.nil?
  end

  # ------- end of study management methods --------


  # irb_number instead of id in urls
  def to_param
    self.irb_number
  end

  def principal_investigator
    roles.detect{|x| x.project_role =~ /P\.?I\.?|Principal Investigator/i}
  end

  def principal_investigator_name
    pi = principal_investigator
    if pi.netid
      u = Bcsec.authority.find_user(pi.netid.downcase)
      if u
        return("#{u.last_name}, #{u.first_name}") 
      end
      return(pi.netid)
    end
    return("Unknown")
  end
 
  def user_roles(netid)
    roles.select{|x| x.netid == netid}
  end

  def has_coordinator?(user)
    roles.map(&:netid).include? user.netid
  end

  def accrual
    if et = event_types.detect{|et| et.name == "Consented"}
      involvement_events.select{|ie| ie.event_type_id == et.id}.size
    else
      0
    end
  end  

  def accrual_during_period(start_date=1.month.ago,end_date=Date.today)
    start_date=start_date.to_date
    end_date=end_date.to_date
    if et = event_types.detect{|et| et.name == "Consented"}
      involvement_events.select{|ie| ie.event_type_id == et.id and ie.occurred_on >= start_date and ie.occurred_on <= end_date}.size
    else
      0
    end
  end  
  
  
  def entries_during_period(start_date=1.month.ago,end_date=Date.today)
    start_date=start_date.to_date
    end_date=end_date.to_date
    involvement_events.select{|ie| ie.created_at >= start_date and ie.created_at <= end_date}.size
  end  

  def can_accrue?
    # For possible eIRB statuses, see doc/terms.csv
    ["Approved", "Exempt Approved", "Not Under IRB Purview",
      "Revision Closed", "Revision Open"].include? self.irb_status
  end

  def define_event(event_name)
    et = event_types.find_by_name(event_name)
    (et.nil?) ? "Undefined event" : et.description
  end

  # Creates new event types for the study
  # These event types are used by involvement events to 
  # indicate what type of event they belong to
  def create_event_type(opts)
    if opts.is_a?(String)
      opts = {:name => opts}
    end
    self.event_types.create(opts)
  end

  # There are some default events we create for every study
  # This method creates those for the current study. 
  # It does not create duplicates if the events exist when 
  # this method is run. Note: The event name is formatted by the EventType class!
  def create_default_events
    EventType::DEFAULT_EVENTS.each_value do |e|
      event = self.event_types.find_by_name(e[:name])
      unless event
        self.event_types.create(e) do |et|
          et.editable = e[:editable] if e.has_key?(:editable)
        end
      end
    end
  end

  def update_default_events
    EventType::DEFAULT_EVENTS.each_value do |e|
      event = self.event_types.find_by_name(e[:name])
      if event
        event.attributes = e
        event.editable = e[:editable] if e.has_key?(:editable)
        event.save
      end
    end
  end

end
