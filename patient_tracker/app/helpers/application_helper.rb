# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def app_version_helper
    "v#{ApplicationController::APP_VERSION}"
  end
  
  def flash_messages(types)
    types.map do |type|      
      content_tag :div, :class => type.to_s do
        "#{type.to_s.capitalize}: #{flash[type]}"
        # message_for_item(flash[type], flash["#{type}_item".to_sym])
      end
    end.join
  end
  
  def nav_link_to(text, path='#', controller=nil)
    link_to(text, path, :class => (@controller.class == controller) ? "current" : "")
  end
  # def message_for_item(message, item = nil)
  #   if item.is_a?(Array)
  #     message % link_to(*item)
  #   else
  #     message
  # end
end
