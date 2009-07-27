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
    study = Study.find_by_irb_number(params[:study]) # Study.find(:first,:conditions=>["irb_number='#{session[:study_irb_number]}'"],:span=>:global)
    
    subject = Subject.find_or_create(params[:subject])
    involvement = Involvement.update_or_create(params[:involvement].merge({:subject => subject, :study => study}))
    involvement.events.create(params[:involvement_event])
    
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
    
    # def validate_subject_params(params)
    #   errors = []
    #   if params[:mrn].blank?
    #     if params[:first_name].blank? and params[:last_name].blank? and Chronic.parse(params[:birth_date]).nil?
    #       errors << "We require an MRN OR first name, last name and Date of Birth"
    #     end
    #   end
    #   errors << "Race is a required field" unless !params[:race].blank?
    #   errors << "Gender AND Ethnicity are required fields" if params[:gender].blank? or params[:ethnicity].blank?
    #   errors << "Event AND corresponding Date are required fields" if params[:event_type].blank? or Chronic.parse(params[:event_date]).nil?
    #   return errors
    # end 
    # 
  end
end
