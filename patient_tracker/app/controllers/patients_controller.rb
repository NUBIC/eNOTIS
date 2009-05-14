class PatientsController < ApplicationController

  def search
    @patients = Patient.find_by_mrn(params[:mrn])
  end
end
