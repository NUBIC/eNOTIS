# This model holds the events that are associated with a subject on
# a study. These would be events that have clinical significance like
# when the subject was consented, screened, withdrawn, etc...

class InvolvementEvent < ActiveRecord::Base

  # Associations
  belongs_to :involvement
  belongs_to :event_type, :class_name => "DictionaryTerm", :foreign_key => :event_type_id
  
  # Named scopes
  named_scope :with_event_types, lambda {|event_type_ids| { :conditions => ['event_type_id in (?)', event_type_ids ]}}
  named_scope :on_study, lambda {|study_id| { :include => :involvement, :conditions => ['involvements.study_id=?', study_id], :order => 'involvement_events.occured_at DESC' } } do
    def to_graph
      results = {}
      (self.blank? ? [] : self).each do |e|
        results[e.occured_at.to_time.to_i*1000] ||= 0
        results[e.occured_at.to_time.to_i*1000] += 1
      end
      total = 0
      results.sort.map{|date, value| [date, total+=value]}
    end
  end
  named_scope :on_studies, lambda {|study_ids| { :include => :involvement, :conditions => ['involvements.study_id in (?)', study_ids], :order => 'involvement_events.occured_at DESC' } }
  
  # Mixins
  has_paper_trail
  
  # Callbacks
  before_destroy :destroy_childless_parent
  
  # Public instance methods
  def term
    event_type.term
  end
  def description
    event_type.description
  end
  
  # Public class methods
  
  # for study_uploads
  def self.sanity_check(params)
    errors = []
    errors << "either MRN or First Name, Last Name and Date of Birth are required" if params[:mrn].blank? and (params[:first_name].blank? or params[:last_name].blank? or Chronic.parse(params[:birth_date]).nil?)
    [ [params[:race], "Race is required"],
      [params[:gender], "Gender is required"],
      [params[:ethnicity], "Ethnicity is required"],
      [params[:event_type], "Event Type is required"],
      [params[:event_date], "Event Date is required"]].each {|val, msg| errors << msg if val.blank?}
    return errors
  end
  
  def self.add(params)
    Study.transaction do # read http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
      # Study - find the study using the hidden field
      study = Study.find_by_irb_number(params[:study][:irb_number]) # Study.find(:first,:conditions=>["irb_number='#{session[:study_irb_number]}'"],:span=>:global)
      # Subject - find or create a subject
      if params[:subject].has_key?(:id) && (subject = Subject.find(params[:subject][:id]))
        involvement = Involvement.find_by_study_id_and_subject_id(study.id, subject.id)
      else
        subject = Subject.find_or_create(params[:subject],study)
        raise ActiveRecord::Rollback if study.nil? or subject.nil?
        # Involvement - create an involvement
        involvement = Involvement.update_or_create(params[:involvement].merge({:subject_id => subject.id, :study_id => study.id}))
      end
      raise ActiveRecord::Rollback if involvement.nil?
      # InvolvementEvent - create the event
      params[:involvement_events].each do |event|
        InvolvementEvent.find_or_create(event.merge({:involvement_id=>involvement.id}))
      end
    end
  end
 
  def self.find_or_create(params)
    InvolvementEvent.find(:first,:conditions => {:involvement_id => params[:involvement_id],:occured_at=>params[:occured_at],:event_type_id=>params[:event_type_id]}) || InvolvementEvent.create(params)
  end
 
  private
  
  # Private instance methods
  def destroy_childless_parent
    if involvement.involvement_events == [self]
      involvement.destroy
    end
  end
end
