class ServicesController < ApplicationController
  # No login required for this controller
  def index
    @studies = current_user ? current_user.studies : []
  end
  def edit
    @study = Study.find_by_irb_number(params[:id])
    return redirect_to services_path unless @study
  end
end
