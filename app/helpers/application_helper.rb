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
    study.may_accrue? ? image_tag('/images/status-on.png', :alt => "O", :title => study.irb_status) : image_tag('/images/status-off.png', :alt => "X", :title => study.irb_status)
  end

  def pretty_irb_number(study)
    m = study.irb_number.match(/(STU0*)(\d*)/)
    if study.irb_number.blank?
      content_tag("span", "(no IRB number)", :class => "irb_number", :title => study.title)
    elsif !m.blank? and !m[1].blank? and !m[2].blank?
      content_tag("span", m[1] + content_tag("strong", m[2]), :class => "irb_number", :title => study.title)
    else
      content_tag("span", study.irb_number, :class => "irb_number", :title => study.title)
    end
  end
  
  def pretty_status(study)
    # the class name affects sorting within study tables
    content_tag(:span, study.irb_status, :class => study.may_accrue? ? "sortabove status on" : "sortbelow status off")
  end
  
  def start_end_info(study)
    [ study.approved_date.blank? ? nil : study.approved_date.strftime("Approved: %b %d, %Y"),
      study.expiration_date.blank? ? nil : study.expiration_date.strftime("Expiration: %b %d, %Y"),
      study.closed_or_completed_date.blank? ? nil : study.closed_or_completed_date.strftime("Closed/completed: %b %d, %Y") ].compact.join("<br/>")
  end
  
  def people_info(arr)
    people = [*arr].compact.map do |p|
      (p.user["first_name"].blank? or p.user["last_name"].blank? or p.user["email"].blank?) ? nil : mail_to(p.user["email"], "#{p.user["first_name"]} #{p.user["last_name"]}", :title => "Project Role: #{p.project_role}")
    end.uniq.compact
    people.empty? ? nil : people.join("<br/>")
  end
  
  def other_studies_flag(involvement)
    unless involvement.subject.involvements == [involvement]
      link_to image_tag('/images/icons/flag_orange.png'), involvement_path(involvement), :rel => '#other_studies'
    end
  end
  
  # Finds an involvement event given a parent involvement and event name
  # 
  # @param [Involvement] involvement parent of the involvement event
  # @param [String] event name of the event to find, case insensitive
  # @return [String, nil] an html span with the event date and note icon (if a note exists). nil if no involvement event found
  def event_info(involvement, event)
    if involvement_event = involvement.involvement_events.detect{|e| e.event.downcase == event.downcase}
      content_tag("span", :class => event.downcase, :title => event){ "#{involvement_event.occurred_on}#{image_tag '/images/icons/note.png' unless involvement_event.note.blank?}" }
    end
  end
  
  def gender_options(selected = nil)
    options_for_select(Involvement.genders, selected)
  end
  
  def ethnicity_options(selected = nil)
    options_for_select(Involvement.ethnicities, selected)
  end
 
  # RACE_ATTRIBUTES is a hash so this method strips the keys and sorts them
  # It also will remove one of the keys (likely the :is_unknown_or_not_reported "Race" 
  # attribute since this attribute we need to handle differently than the others)
  def race_options(key_to_delete)
    keys = Involvement::RACE_ATTRIBUTES.keys.sort{|a,b| a.to_s <=> b.to_s}
    keys.delete(key_to_delete.to_sym)
    keys  
  end
  
  def event_options(selected = nil)
    options_for_select(InvolvementEvent.events, selected)
  end
end
