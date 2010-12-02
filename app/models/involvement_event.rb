require 'ruport'
# This model holds the events that are associated with a subject on
# a study. These would be events that have clinical significance like
# when the subject was consented, withdrawn, etc...

class InvolvementEvent < ActiveRecord::Base
  # Mixins
  has_paper_trail
  acts_as_reportable
  
  # Associations
  belongs_to :involvement
  belongs_to :event_type
   
  # Validations
  # validates_presence_of :involvement
  # this validation will work in possibly a new version on Rails. Curently broke.
  # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/2815-nested-models-build-should-directly-assign-the-parent

  validates_presence_of :occurred_on
  validates_presence_of :event_type_id
  validates_uniqueness_of :event_type_id, :scope => [:involvement_id, :occurred_on], :message => "This activity on this date has already been entered"
  
  # Named scopes
  default_scope :order => "occurred_on"
  named_scope :accruals, {
    :joins => :event_type,
    :conditions => "event_types.name = 'Consented'"}
  
  named_scope :in_last_12_months, { :conditions => { :occurred_on => 12.months.ago..Date.today }}
  named_scope :on_study, lambda {|study_id| {
    :include => :involvement,
    :conditions => ['involvements.study_id=?', study_id], :order => 'involvement_events.occurred_on DESC' } } do
    def to_graph
      results = {}
      (self.blank? ? [] : self).each do |e|
        results[e.occurred_on.to_time.to_i*1000] ||= 0
        results[e.occurred_on.to_time.to_i*1000] += 1
      end
      total = 0
      results.sort.map{|date, value| [date, total+=value]}
    end
    
    def to_time_chart
      # 0th array is xaxis, 1st array is accruals by month, 2nd array is total
      months = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
      monthly = Array.new(12, 0)
      totals = Array.new(12, 0)

      cutoff = 11.months.ago.at_beginning_of_month.to_datetime
      lastyear, thisyear = (self.blank? ? [] : self).partition{|e| e.occurred_on < cutoff }
      thisyear.each{|e| monthly[e.occurred_on.month - 1] += 1 }
      pretotal = lastyear.count
      
      months.rotate(Date.today.month)
      monthly.rotate(Date.today.month)
      monthly.each_with_index{|obj, i| totals[i] = (i == 0 ? pretotal : totals[i-1]) + monthly[i] }
      [months, monthly, totals]
    end

    def to_dot_chart
      results = Array.new(12 * 7, 0)
      (self.blank? ? [] : self).each do |e|
        # pos is position in the bubble chart array
        # the chart runs left (Jan) to right (Dec), bottom (Sun) to top (Sat)
        # pos = 12*((7 - e.occurred_on.wday)%7) + (e.occurred_on.month - 1)
        # results[pos] += 1
        pos = 12*e.occurred_on.wday + (e.occurred_on.month - 1)
        results[pos] += 1
      end
      results
    end
  end
  
  named_scope :on_studies, lambda {|study_ids| { :include => :involvement, :conditions => ['involvements.study_id in (?)', study_ids], :order => 'involvement_events.occurred_on DESC' } }
  
  # Callbacks
  after_destroy :destroy_childless_parent

  # Public instance methods
  def occurred_on=(date)
    write_attribute :occurred_on, Chronic.parse(date)
  end

  def event=(e)
    # This assignment will fail without the involvement and study context because the event names are now stored on the study level -BLC
    raise "Involvement event= assignment this way requires study context: involvement=#{self.involvement.inspect}" if self.involvement.nil? or self.involvement.study.nil?
    ev_type = self.involvement.study.event_types.find_by_name(e)
    self.event_type = ev_type if ev_type
  end
  
  def event
     (self.event_type) ? self.event_type.name : nil 
  end

  # for study_uploads, and external event processor
  def self.add(params)
    Study.transaction do # read http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
      # Study - find the study using the hidden field
      study = Study.find_by_irb_number(params[:study][:irb_number]) 
      # Subject - create a subject
      if params[:subject].has_key?(:id) && (subject = Subject.find(params[:subject][:id]))
        involvement = Involvement.find_by_study_id_and_subject_id(study.id, subject.id)
      else
        subject = Subject.create(params[:subject])
        raise ActiveRecord::Rollback if study.nil? or subject.nil?
        # Involvement - create an involvement
        involvement = Involvement.update_or_create(params[:involvement].merge({:subject_id => subject.id, :study_id => study.id}))
      end
      raise ActiveRecord::Rollback if involvement.nil? or involvement.id.nil?
      involvement.save
      # InvolvementEvent - create the event
      params[:involvement_events].each do |event|
        InvolvementEvent.find_or_create(event.merge({:involvement_id=>involvement.id}))
      end
    end
  end

  def self.find_or_create(params)
     # logger.debug "find_or_create all inv_evnt: #{InvolvementEvent.find(:all).inspect}"
     inv = Involvement.find(params[:involvement_id])
     return nil if inv.nil? || params[:occurred_on].blank?
     etype = inv.study.event_types.find_by_name(params[:event])
     params.delete(:event)
     params[:event_type_id] = etype.id
     InvolvementEvent.find(:first, :conditions => { 
       :involvement_id => inv.id, 
       :occurred_on    => Chronic.parse(params[:occurred_on]), 
       :event_type_id          => etype.id }
     ) || InvolvementEvent.create(params)
   end            

 
  def self.count_accruals(accrual_event = "Consented")
    e_types = EventType.find_by_name(accrual_event) 
    InvolvementEvent.count(:involvement_id, :distinct => true, :conditions => ["event_type_id in (#{e_types.map{|e| e.id}})"])
  end
 
  private
  
  # Private instance methods
  def destroy_childless_parent
    involvement.destroy if involvement && involvement.involvement_events == []
  end
end
