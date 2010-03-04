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
    study.may_accrue? ? image_tag('/images/status-on.png', :alt => "O") : image_tag('/images/status-off.png', :alt => "X")
  end
  
  def people_info(arr, title)
    people = arr.compact.map do |p|
      (p["first_name"].blank? or p["last_name"].blank? or p["email"].blank?) ? nil : "#{p["first_name"]} #{p["last_name"]} " + mail_to(p["email"])
    end.uniq.compact
    people.empty? ? nil : "#{title}: " + people.join(", ") + "<br/>"
  end
  
  def event_info(involvement, event_type)
    if event = involvement.involvement_events.detect{|e| e.event_type_id == DictionaryTerm.event_id(event_type)}
      content_tag("span", :class => event_type, :title => event_type.capitalize){ "#{event.occurred_on}#{image_tag '/images/icons/note.png' unless event.note.blank?}" }
    end
  end
  
  def gender_options
    options_for_select(DictionaryTerm.gender_objects.map{|g| [g.term.titleize, g.id]})
  end
  def ethnicity_options
    options_for_select(DictionaryTerm.ethnicity_objects.map{|e| [e.term.titleize, e.id]})
  end
  def completed_options
    options_for_select(%w(completed withdrawn).map{|t| DictionaryTerm.event(t)}.map{|t| [t.term.titleize, t.id]})
  end
end
