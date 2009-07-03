class InvolvementEventsController < ApplicationController
  layout "layouts/main"
  include FaceboxRender

  def index
    @events = current_user.studies.map(&:involvements).flatten.map(&:involvement_events).flatten
  end
  def new
    respond_to do |format|
      format.html
      format.js {render_to_facebox}
    end
  end
  def create
    @subject = Subject.find_by_mrn(params[:mrn])
    @study = Study.find_by_id(session[:study_id])
    if @subject and @study and @involvement = @study.add_subject(@subject)
      respond_to do |format|
        format.html do
          flash[:notice] = "Success"
          redirect_to study_path(@study)
        end
        format.js do
          render_to_facebox :html => "success"
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:notice] = "Fail"
          redirect_to @study ? study_path(@study) : studies_path
        end
        format.js do
          render_to_facebox :html => "#{@subject.inspect}: #{@study.inspect}: #{@involvement.inspect}"
        end
      end
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
