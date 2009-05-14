class PatientsController < ApplicationController
layout "layouts/loggedin"

  def search
    @patients = Patient.find_by_mrn(params[:mrn])
  end
end
