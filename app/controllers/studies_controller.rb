class StudiesController < ApplicationController
  layout "main"
  require 'array'

  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user

  # Auditing
  has_view_trail :except => :index
  
  # Public instance methods (actions)
  def index
    @title = "Studies"
    # raise "testing exception notifier - yoon" # http://weblog.jamisbuck.org/2007/3/7/raising-the-right-exception
    
    # json datatables is causing issues with IE in some cases, and optimizes a problem that we don't really have (slow "my studies" page).
    
    respond_to do |format|
      format.html do
        @my_studies = Study.with_user(current_user.netid)
      end
      format.json do
        render :json => Study.with_user(current_user.netid).to_json
      end
    end
  end

  def show
    @study = Study.find_by_irb_number(params[:id])#, :include => [{:involvements => [{:subject => :involvements}, :involvement_events]}, :roles])
    if @study
      authorize! :show, @study
      @title = @study.irb_number
      @involvements = @study.involvements(:order => "case_number")
      unless @involvements.empty?       
        @ethnicity_stats = @involvements.count_all(:short_ethnicity)
        @gender_stats = @involvements.count_all(:short_gender)
        @race_stats = @involvements.count_all(:short_race)
        @time_stats = InvolvementEvent.accruals.on_study(@study).to_time_chart
        @dot_stats = InvolvementEvent.accruals.on_study(@study).to_dot_chart.inspect
      end
    else
      redirect_to studies_path
    end
  end
  
  def import
    @study = Study.find_by_irb_number(params[:id])
    authorize! :import, @study
    @uploads = @study.study_uploads
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
  
  def help
    #?? help page? TODO: remove this -BLC    
  end


end
