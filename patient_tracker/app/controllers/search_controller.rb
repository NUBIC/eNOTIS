class SearchController < ApplicationController
  before_filter :user_must_be_logged_in
  layout "main"
  def show
    if q = params[:query]
      @subjects = current_user.studies.map do |study|
        study.subjects.first_name_like(q) + study.subjects.last_name_like(q)
      end.flatten
      @studies = Study.title_like(q) + Study.status_like(q)
    end
  end

end
