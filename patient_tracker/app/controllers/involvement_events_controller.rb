class InvolvementEventsController < ApplicationController
  layout "layouts/main"
  include FaceboxRender
  def new
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end
  def create
    params[:study_id] = session[:study_id]
    @subject = Subject.find_by_mrn(params[:mrn])
    @study = Subject.find_by_study_id(session[:study_id])
    @study.add_subject(@subject)
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end  
  end  
  def search
    if not params[:no_mrn]
      @subject = Subject.find_by_mrn(params[:mrn])
    end
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end
end
