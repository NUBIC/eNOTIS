require 'chronic'

# Represents a Clinical Study/Trial.
class Study < ActiveRecord::Base
  named_scope :paged, lambda {|start, limit| { :offset => start ,:limit => limit}}
  named_scope :order, lambda {|order| { :order => order}}
  
  # Associations
  has_many :involvements
  has_many :roles
  has_many :subjects, :through => :involvements
  has_many :involvement_events, :through => :involvements
  has_many :study_uploads
  has_many :funding_sources, :dependent => :delete_all
  has_many :event_types, :order => "seq asc" do 
    def find_by_name(e_name)
      find(:first, :conditions => {:name =>EventType.event_name_formatter(e_name)})
    end
  end
  
  # Validators
  validates_format_of :irb_number, :with => /^STU.+/, :message => "invalid study number format"
    
  def self.update_from_redis
    study_list = REDIS.keys 'study:*'
    study_list.reject! {|x| x =~ /funding_source/ }
    study_list.each do |redis_study|
      study  = HashWithIndifferentAccess.new(REDIS.hgetall(redis_study))
      params = {
        :accrual_goal                      => study[:accrual_goal], 
        :approved_date                     => Chronic.parse(study[:approved_date]),
        :clinical_trial_submitter          => study[:clinical_trial_submitter], 
        :closed_or_completed_date          => Chronic.parse(study[:closed_or_completed_date]),
        :created_date                      => Chronic.parse(study[:created_date]),
        :description                       => study[:description],
        :exclusion_criteria                => study[:exclusion_criteria],
        :expiration_date                   => Chronic.parse(study[:expiration_date]),
        :expired_date                      => Chronic.parse(study[:expired_date]), 
        :fda_offlabel_agent                => study[:fda_offlabel_agent],
        :fda_unapproved_agent              => study[:fda_unapproved_agent],
        :inclusion_criteria                => study[:inclusion_criteria],
        :irb_number                        => study[:irb_number],
        :irb_status                        => study[:irb_status],
        :is_a_clinical_investigation       => study[:is_a_clinical_investigation],
        :modified_date                     => Chronic.parse(study[:modified_date]),
        :name                              => study[:name],
        :periodic_review_open              => study[:periodic_review_open],
        :research_type                     => study[:research_type],
        :review_type_requested             => study[:review_type_requested],
        :subject_expected_completion_count => study[:subject_expected_completion_count],
        :title                             => study[:title],
        :total_subjects_at_all_ctrs        => study[:total_subjects_at_all_ctrs]
      }
      local_study = find_by_irb_number(params[:irb_number])
      if local_study.nil?
        local_study = create(params)
      else
        local_study.update_attributes!(params)
      end

      # Processing funding sources for the study (a child/parent relationship with the study)
      local_study.funding_sources.clear # TODO: Another alternative is to use the "unique" id from the eIRB query for each funding source to avoid having to drop all and re-add. -BLC
      funding_srcs = REDIS.keys "study:#{params[:irb_number]}:funding_source:*"
      funding_srcs.each do |redis_study_src|
        src =  HashWithIndifferentAccess.new(REDIS.hgetall(redis_study_src))
        src_params = {:name => src[:funding_source_name],
          :code => src[:funding_source_id], 
          :category => src[:funding_source_category_name]}
        local_study.funding_sources.create(src_params) unless src[:funding_source_name].blank?
      end
    end
  end

  # This method is used to toggle the editable/non-editable state of 
  # patients and patient data (ie involvments, involvment_events, subjects).
  # Added to support the import of study subjects managed by NOTIS
  def read_only!(msg = nil)
    self.read_only = true
    self.read_only_msg = msg
  end

  def editable!
    self.read_only = false
    self.read_only_msg = nil
  end

  def read_only?
    self.read_only
  end

  def editable?
    !self.read_only
  end
  # We should probably try to phase this method out and just use irb_status -BLC
  def status
    irb_status
  end

  # irb_number instead of id in urls
  def to_param
    self.irb_number
  end

  def has_role?(user)
    user.admin? or roles.map(&:netid).include? user.netid
  end
  
  # Temporary for demo
  def principal_investigator
    roles.detect{|x| x.project_role =~ /P\.?I\.?|Principal Investigator/i}
  end
  
  #TODO: This is a temporary fix -BLC
  # We need to phase out these named roles for a more binary authorization
  # for can_accrue ==true (ie view/edit patients) vs can_accrue ==false (can only view)
  def has_coordinator?(user)
    has_role?(user)
  end

  def accrual
    et = event_types.find_by_name("Consented")
    if et
      involvement_events.count(:conditions => {:event_type_id => et.id})
    else
      0
    end
  end  

  def may_accrue?
    can_accrue?
  end

  def can_accrue?
    # For possible eIRB statuses, see doc/terms.csv
    ["Approved", "Exempt Approved", "Not Under IRB Purview",
      "Revision Closed", "Revision Open"].include? self.status
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
