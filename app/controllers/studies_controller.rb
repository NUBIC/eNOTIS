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

  def edit
    @study = Study.find_by_irb_number(params[:id])
    @uneditable_events, @editable_events = @study.event_types.partition{|ev| ev.editable == false }
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def show
    @study = Study.find_by_irb_number(params[:id], :include => :roles)
    if @study
      @involvements = @study.involvements
      @title = @study.irb_number
      #authorize! :show, @study
      #@title = @study.irb_number
      # Querying based on involvement to allow for server-side
      # pagination later if necessary.
      #@involvements = Involvement.find_all_by_study_id(@study.id,
      #  :order => :case_number,
      #  :include => [ :response_sets,{ :subject => :involvements }, { :involvement_events => :event_type } ]
      #)
      #unless @involvements.empty?
      #  @ethnicity_stats = @involvements.count_all(:short_ethnicity)
      #  @gender_stats = @involvements.count_all(:short_gender)
      #  @race_stats = @involvements.count_all(:short_race)
      #  @time_stats = InvolvementEvent.accruals.on_study(@study).to_time_chart
      #  @dot_stats = InvolvementEvent.accruals.on_study(@study).to_dot_chart.inspect
      #end
    else
      redirect_to studies_path
    end
  end

  def charts
    @study = Study.find_by_irb_number(params[:id], :include => :roles)
    @involvements = @study.involvements
    unless @involvements.empty?
        @ethnicity_stats = @involvements.count_all(:short_ethnicity)
        @gender_stats = @involvements.count_all(:short_gender)
        @race_stats = @involvements.count_all(:short_race)
        @time_stats = InvolvementEvent.accruals.on_study(@study).to_time_chart
        @dot_stats = InvolvementEvent.accruals.on_study(@study).to_dot_chart.inspect
    end
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def help
    #?? help page? TODO: remove this -BLC
  end
end
