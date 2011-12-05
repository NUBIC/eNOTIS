class ReportsController < ApplicationController
  layout "main"

  # Authorization
  include Bcsec::Rails::SecuredController
  permit :user

  has_view_trail :except => :index

  def index
    @study = Study.find_by_irb_number(params[:study])
    authorize! :show, @study
  end

  def nih
    @study = Study.find_by_irb_number(params[:study])
    authorize! :show,@study
    @involvements = @study.involvements
    render :layout => 'nih_report'
  end
 
  def new
    @study = Study.find_by_irb_number(params[:study])
    authorize! :show, @study
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def show;  end

  def create
    study = Study.find_by_irb_number(params[:study][:irb_number])
    authorize! :show, study
    result = Report.export(params)
    send_data(result,:type => 'text/csv; charset=utf-8; header=present',:filename => "#{params[:study][:irb_number]}.csv")
  end

  def render_report(report);  end
  
end
