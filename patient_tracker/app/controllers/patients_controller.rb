class PatientsController < ApplicationController
  include AuthMod
  include PatientRequests
  before_filter :user_must_be_logged_in
  layout "layouts/loggedin"

  def search
    @patients = Patient.find_by_mrn(params[:mrn])
  end
end
