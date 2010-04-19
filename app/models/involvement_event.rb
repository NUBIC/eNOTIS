require 'ruport'
# This model holds the events that are associated with a subject on
# a study. These would be events that have clinical significance like
# when the subject was consented, withdrawn, etc...

class InvolvementEvent < ActiveRecord::Base
  acts_as_reportable
  # Associations
  belongs_to :involvement
  
  # Validations
  validates_uniqueness_of :event, :scope => [:involvement_id, :occurred_on], :message => "This activity and date has already been entered"
  
  # Named scopes
  default_scope :order => "occurred_on"
  named_scope :on_study, lambda {|study_id| { :include => :involvement, :conditions => ['involvements.study_id=?', study_id], :order => 'involvement_events.occurred_on DESC' } } do
    def to_graph
      results = {}
      (self.blank? ? [] : self).each do |e|
        results[e.occurred_on.to_time.to_i*1000] ||= 0
        results[e.occurred_on.to_time.to_i*1000] += 1
      end
      total = 0
      results.sort.map{|date, value| [date, total+=value]}
    end
  end
  named_scope :on_studies, lambda {|study_ids| { :include => :involvement, :conditions => ['involvements.study_id in (?)', study_ids], :order => 'involvement_events.occurred_on DESC' } }
  
  # Mixins
  has_paper_trail
  
  # Callbacks
  before_destroy :destroy_childless_parent

  # Public instance methods
  def occurred_on=(date)
    write_attribute :occurred_on, Chronic.parse(date)
  end

  # Public class methods
  class << self 
    def event_definitions 
      [ ["Consented", "Subject has signed informed consent forms."],
        ["Completed", "Subject has completed study and is no longer receiving treatment/s or services."],
        ["Withdrawn", "Subject has been removed from study (include notes field for reason/description)."] ]
    end
    def events
      self.event_definitions.transpose[0]
    end
    def define_event(term)
      (self.event_definitions.detect{|t,d| t == term} || [])[1]
    end
  end

  # for study_uploads
  def self.add(params)
    Study.transaction do # read http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
      # Study - find the study using the hidden field
      study = Study.find_by_irb_number(params[:study][:irb_number]) 
      # Subject - find or create a subject
      if params[:subject].has_key?(:id) && (subject = Subject.find(params[:subject][:id]))
        involvement = Involvement.find_by_study_id_and_subject_id(study.id, subject.id)
      else
        subject = Subject.find_or_create(params)
        raise ActiveRecord::Rollback if study.nil? or subject.nil?
        # Involvement - create an involvement
        involvement = Involvement.update_or_create(params[:involvement].merge({:subject_id => subject.id, :study_id => study.id}))
      end
      raise ActiveRecord::Rollback if involvement.nil? or involvement.id.nil?
      # InvolvementEvent - create the event
      params[:involvement_events].each do |event|
        InvolvementEvent.find_or_create(event.merge({:involvement_id=>involvement.id}))
      end
    end
  end
 
  def self.find_or_create(params)
    # logger.debug "find_or_create all inv_evnt: #{InvolvementEvent.find(:all).inspect}"
    return nil if params[:occurred_on].blank?
    InvolvementEvent.find(:first, :conditions => { 
      :involvement_id => params[:involvement_id], 
      :occurred_on    => Chronic.parse(params[:occurred_on]), 
      :event          => params[:event] }
    ) || InvolvementEvent.create(params)
  end
  
  def self.count_accruals
    InvolvementEvent.count(:involvement_id, :distinct => true, :conditions => ["event =? ", "Consented"])
  end
 
  private
  
  # Private instance methods
  def destroy_childless_parent
    if involvement.involvement_events == [self]
      involvement.destroy
    end
  end
end
