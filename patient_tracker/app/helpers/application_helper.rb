# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def app_version_helper
    "v#{ApplicationController::APP_VERSION}"
  end

end
