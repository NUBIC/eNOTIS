# This model holds the events that are associated with a subject on
# a study. These would be events that have clinical significance like
# when the subject was consented, screened, withdrawn, etc...

class InvolvementEvent < ActiveRecord::Base

  # Associations
  belongs_to :involvement
  has_one :event_type, :class_name => "DictionaryTerm"
  
  # Mixins
  has_paper_trail

  # Class methods
  
  def self.add_via_ui(params)
    # params (new)
    # { "involvement_event"=>
    #     { "note"=>"", 
    #       "event_type"=>"7", 
    #       "event_date"=>""}, 
    #   "action"=>"create", 
    #   "authenticity_token"=>"XYZ", 
    #   "subject"=>
    #     { "birth_date"=>"", 
    #       "last_name"=>"", 
    #       "mrn"=>"", 
    #       "first_name"=>""}, 
    #   "involvement"=>
    #     { "ethnicity"=>"29", 
    #       "gender"=>"25", 
    #       "race"=>"33"}, 
    #   "controller"=>"involvement_events"}

    # Study - find the study using the hidden field
    study = Study.find_by_irb_number(params[:study][:irb_number]) # Study.find(:first,:conditions=>["irb_number='#{session[:study_irb_number]}'"],:span=>:global)
    return {:error => "a study is required, please visit the appropriate study and try again"} if study.nil?
    # Subject - find or create a subject
    subject = Subject.find_or_create(params[:subject])
    return {:error => "either MRN or First Name, Last Name and Date of Birth are required"} if subject.nil?
    # Involvement - create an involvement, raise an error if it already exists
    return {:error => "Gender AND Ethnicity are required fields"} if params[:involvement][:gender_type_id].blank? or params[:involvement][:ethnicity_type_id].blank?
    return {:error => "this subject is already associated with this study"} if Involvement.find_by_study_id_and_subject_id(study.id, subject.id)
    involvement = Involvement.create(params[:involvement].merge({:subject_id => subject.id, :study_id => study.id}))
    # InvolvementEvent - create the event
    return {:error => "Event AND corresponding Date are required fields"} if params[:involvement_event][:event_type_id].blank? or Chronic.parse(params[:involvement_event][:occured_at]).nil?
    involvement.involvement_events.create(params[:involvement_event])
    
    # params (old)
    # { "ethnicity"=>"29", 
    #   "action"=>"create", 
    #   "authenticity_token"=>"Sg/9X9yAlbvUbid+fj3F7Ruc1r/KO0/XOM+81neIkH4=", 
    #   "birth_date"=>"", 
    #   "gender"=>"25", 
    #   "last_name"=>"", 
    #   "note"=>"", 
    #   "controller"=>"involvement_events", 
    #   "mrn"=>"", 
    #   "event_type"=>"7", 
    #   "first_name"=>"", 
    #   "race"=>"33", 
    #   "event_date"=>"",
    #   "study"=>"STU009999028" }
  end
end
