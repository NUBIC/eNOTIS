# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Helper to display application version
  def app_version_helper
    "v#{ApplicationController::APP_VERSION}"
  end
  
  # Helper for displaying warning/notice/error flash messages
  def flash_messages(types)
    types.map{|type| content_tag(:div, :class => type.to_s){ "#{flash[type]}" } }.join
  end
  
  def status_icon(study)
    # study.may_accrue? ? "O" : "X"
    study.may_accrue? ? image_tag('/images/status-on.png') : image_tag('/images/status-off.png')
  end
end
