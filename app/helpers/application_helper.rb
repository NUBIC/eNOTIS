# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Helper to display application version
  def app_version_helper
    "v#{ApplicationController::APP_VERSION}"
  end
  
  # Helper for displaying warning/notice/error flash messages
  def flash_messages(types)
    types.map{|type| content_tag(:div, :class => type.to_s){ "#{type.to_s.capitalize}: #{flash[type]}" } }.join
  end
  
  def nav_class(controller=nil)
    @controller.class == controller ? "current" : ""
  end
  
  # Helper for study tabs. Used in app/views/studies/show
  def study_tab_to(text, path='#')
    link_to(text, path, {:class => path != "#" ? "current" : ""})
  end
end
