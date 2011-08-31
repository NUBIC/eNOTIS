module PublicSurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'
     base.send :layout, 'public_surveyor'
  end

  # Actions

  def new
    @survey = Survey.find_by_access_code(params[:survey_code])
    respond_to do |format|
      format.js {render :layout => false}
      format.html
    end
  end

  def create
    @survey = Survey.find_by_access_code(params[:survey_code])    
    @involvement = @survey.study.involvements.find_by_uuid(params[:uuid])
    if @involvement.blank?
      flash[:notice] = "Unknown access code"
      return redirect_to take_public_survey_path(:survey_code=>@survey.access_code)
    end
    @response_set = @survey.response_sets.find_by_involvement_id(@involvement.id) || @survey.response_sets.create(:involvement_id => @involvement.id,:effective_date=>Date.today)
    unless @response_set.completed_at.blank?
      flash[:notice] = "survey complete"
      return redirect_to take_public_survey_path(:survey_code=>@survey.access_code)
    end
    redirect_to(edit_my_public_survey_path(:survey_code => @survey.access_code, :response_set_code  => @response_set.access_code))
  end



  def edit
    super
  end

  def update
      @response_set = ResponseSet.find_by_access_code(params[:response_set_code], :include => {:responses => :answer})
      return redirect_with_message(available_surveys_path, :notice, t('surveyor.unable_to_find_your_responses')) if @response_set.blank?
      saved = false
      ActiveRecord::Base.transaction do
        @response_set = ResponseSet.find_by_access_code(params[:response_set_code], :include => {:responses => :answer},:lock=>true)
        saved = @response_set.update_attributes(:responses_attributes => ResponseSet.reject_or_destroy_blanks(params[:r]))
        saved &=@response_set.complete_with_validation! if saved && params[:finish]
      end
     return redirect_to(edit_my_public_survey_path({:review=>true,:section=>@response_set.first_incomplete_section,:response_set_code=>@response_set.access_code})) if params[:finish] and !saved
     if saved && params[:finish]
       next_response_set = @response_set.next
       return redirect_to take_public_survey_path(@response_set.survey.access_code) if next_response_set.nil?
       return redirect_to edit_my_public_survey_path(:survey_code => next_response_set.survey.access_code,:response_set_code  => next_response_set.access_code) 
     end
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
class PublicSurveyorController < ApplicationController
  include Surveyor::SurveyorControllerMethods
  include PublicSurveyorControllerCustomMethods
end
