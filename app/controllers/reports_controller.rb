class ReportsController < ApplicationController
  layout "layouts/main"  

  before_filter :user_must_be_logged_in
  has_view_trail :except => :index

  def index
    @study = Study.find_by_irb_number(params[:study])
  end

  def nih
    @study = Study.find_by_irb_number(params[:study])
    @involvements = @study.involvements
    render :layout => 'nih_report'
  end
 
  def new
    @study = Study.find_by_irb_number(params[:study])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end

  def show;  end

  def create
    result = Report.export(params)
    if params[:format]=="pdf"
      send_data(result,
                :type => 'application/pdf',
                :filename =>  "#{params[:study][:irb_number]}.pdf")
    elsif params[:format]=="csv"
      send_data(result,
                :type => 'text/csv; charset=utf-8; header=present',
                :filename => "#{params[:study][:irb_number]}.csv")
    end
  end

  def render_report(report);  end
  
end
