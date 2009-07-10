class SearchController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "main"
  def show
    if q = params[:query]
      @subjects = current_user.studies.map do |study|
        study.subjects.first_name_like(q) + study.subjects.last_name_like(q)
      end.flatten
      @studies = Study.title_like(q) + Study.status_like(q) + Study.irb_number_like(q)
    end
  end

end

# # Involvement Events
# def search
#   if !params[:mrn].blank?
#     subject = Subject.find(:first,:conditions=>["mrn='#{params[:mrn]}'"],:span=>:global)
#     @subjects = [subject] || []
#   elsif !params[:first_name].blank? and !params[:last_name].blank? and !params[:birth_date].blank?
#     @subjects = Subject.find(:all,:conditions=> ["first_name = #{params[:first_name]} and last_name = #{params[:last_name]} and birth_date = #{params[:birth_date]}"],:span=>:foreign)
#   end
#   respond_to do |format|
#     format.html
#     format.js {render_to_facebox}
#   end
# end

# # Studies
# def search
#   if params[:query] and @study = (Study.find_by_irb_number(params[:query]) || Study.find(:first, :conditions => [ "title like ?", "%#{params[:query]}%"]) )
#     render(:action => "show")
#   else
#     flash[:notice] = "No studies found"
#     redirect_to :back
#   end
# end

# # Subjects
# def search
#   @subjects = Subject.find_by_mrn(params[:mrn])
# end