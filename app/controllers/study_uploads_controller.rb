class StudyUploadsController < ApplicationController
  layout "main"
  require 'array'

  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user

  # Auditing
  has_view_trail :except => :index

  # Public instance methods (actions)

  def index
    @study = Study.find_by_irb_number(params[:study_id])
    authorize! :import, @study
    @uploads = @study.study_uploads
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def show
    @upload = StudyUpload.find(params[:id])
   upload = File.read(@upload.send(params[:type].to_sym).path)
   send_data(upload,:filename=>params[:type],:content_type => 'text/csv')
  end

  def create
    @study = Study.find_by_irb_number(params[:study_id]) # || Study.new # <= Why are we calling Study.new here? -BLC
    authorize! :import, @study
    @up = StudyUpload.create(:netid => current_user.netid, :study_id => @study.id, :upload => params[:file])
    flash[:notice] = (!@up.upload_exists? or @up.legit?) ? @up.summary : "Oops. Your upload had some issues.<br/>Please click <a href='#{@study.irb_number ? import_study_path(@study) : '#'}' rel='#import'>Import</a> to see the result."
    redirect_to study_path(@study)
  end
end
