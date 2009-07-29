# This model holds the events that are associated with a subject on
# a study. These would be events that have clinical significance like
# when the subject was consented, screened, withdrawn, etc...

class InvolvementEvent < ActiveRecord::Base

  # Associations
  belongs_to :involvement
  belongs_to :event_type, :class_name => "DictionaryTerm", :foreign_key => :event_type_id
  
  # Mixins
  has_paper_trail
  
  # Public instance methods
  
  # Public class methods
  
  # for study_uploads
  def self.sanity_check(params)
    errors = []
    errors << "either MRN or First Name, Last Name and Date of Birth are required" if params[:mrn].blank? and (params[:first_name].blank? or params[:last_name].blank? or Chronic.parse(params[:birth_date]).nil?)
    [ [params[:irb_number], "Study is required, please visit the appropriate study and try again"],
      [params[:race], "Race is required"],
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
      subject = Subject.find_or_create(params[:subject])
      raise ActiveRecord::Rollback if study.nil? or subject.nil?
      # Involvement - create an involvement
      involvement = Involvement.create(params[:involvement].merge({:subject_id => subject.id, :study_id => study.id}))
      # InvolvementEvent - create the event
      involvement.involvement_events.create(params[:involvement_event])
    end
  end
end
