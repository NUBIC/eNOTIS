module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
     base.send :include, Bcsec::Rails::SecuredController
     base.send :layout, 'surveyor'
     base.send :permit, :user
  end

  # Actions
  def new
    @involvement = Involvement.find(params[:involvement_id])
    @surveys = Study.find(params[:study_id]).surveys
    @title = "Forms for Study  #{params[:irb_number]}"
    #redirect_to surveyor_index unless surveyor_index == available_surveys_path
    respond_to do |format|
      format.js {render :layout => false}
    # @title = "You can take these surveys"
    end
  end
  def create
       @survey = Survey.find_by_access_code(params[:active_survey_code])
       @response_set = ResponseSet.create(:survey => @survey, :involvement_id => params[:involvement_id],:effective_date=>params[:effective_date] || Date.today)
       if (@survey && @response_set)
         flash[:notice] = t('surveyor.survey_started_success')
         redirect_to(edit_my_survey_path(:survey_code => @survey.access_code, :response_set_code  => @response_set.access_code))
       else
         flash[:notice] = t('surveyor.Unable_to_find_that_survey')
         redirect_to studies_path
       end
  end
  def show
    super
  end
  def edit
    super
  end
  def update
      @response_set = ResponseSet.find_by_access_code(params[:response_set_code], :include => {:responses => :answer})
      return redirect_with_message(available_surveys_path, :notice, t('surveyor.unable_to_find_your_responses')) if @response_set.blank?
      saved = false
      ActiveRecord::Base.transaction do
        @response_set = ResponseSet.find_by_access_code(params[:response_set_code], :include => {:responses => :answer}, :lock => true)
        saved = @response_set.update_attributes(:responses_attributes => ResponseSet.reject_or_destroy_blanks(params[:r]))
        saved &=@response_set.complete_with_validation! if saved && params[:finish]
        #saved &= @response_set.save
      end
     return redirect_to(edit_my_survey_path({:review=>true,:section=>@response_set.first_incomplete_section,:response_set_code=>@response_set.access_code})) if params[:finish] and !saved
      return redirect_to study_path(@response_set.survey.study) if saved && params[:finish]
      respond_to do |format|
        format.html do
          flash[:notice] = t('surveyor.unable_to_update_survey') unless saved
          redirect_to :action => "edit", :anchor => anchor_from(params[:section]), :params => {:section => section_id_from(params[:section])}
        end
        format.js do
          ids, remove, question_ids = {}, {}, []
          ResponseSet.reject_or_destroy_blanks(params[:r]).each do |k,v|
            v[:answer_id].reject!(&:blank?) if v[:answer_id].is_a?(Array)
            ids[k] = @response_set.responses.find(:first, :conditions => v).id if !v.has_key?("id")
            remove[k] = v["id"] if v.has_key?("id") && v.has_key?("_destroy")
            question_ids << v["question_id"]
          end
          render :json => {"ids" => ids, "remove" => remove}.merge(@response_set.reload.all_dependencies(question_ids))
        end
      end
  end
  
  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    super # available_surveys_path
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    super # available_surveys_path
  end
end
class SurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
end
