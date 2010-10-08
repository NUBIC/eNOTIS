require 'uri'
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Helper to display application version
  def app_version_helper
    "v#{ApplicationController::APP_VERSION}"
  end
  
  # Helper for displaying warning/notice/error flash messages
  def flash_messages(types)
    types.map{|type| content_tag(:div, "#{flash[type]}".html_safe, :class => type.to_s)}.join.html_safe
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
      content_tag("span", "#{m[1]}<strong>#{m[2]}</strong>".html_safe, :class => "irb_number", :title => study.title)
    else
      content_tag("span", study.irb_number, :class => "irb_number", :title => study.title)
    end
  end
  
  def pretty_status(study)
    # the class name affects sorting within study tables
    content_tag(:span, study.irb_status, :class => study.may_accrue? ? "sortabove status on" : "sortbelow status off")
  end

  def approved_date(study)
    study.approved_date.blank? ? nil : study.approved_date.strftime("%b %d, %Y")
  end
  
  def expiration_date(study)
    study.expiration_date.blank? ? nil : study.expiration_date.strftime("%b %d, %Y")
  end

  def closed_completed_date(study)
    study.closed_or_completed_date.blank? ? "N/A" : study.closed_or_completed_date.strftime("%b %d, %Y") 
  end
  
  def people_info(arr)
    people = [*arr].compact.map do |p|
      person_info(p)
    end.uniq.compact
    (people.empty? ? nil : people.join(", ").html_safe)
  end
 
  def person_info(p)
    (p.user["first_name"].blank? or p.user["last_name"].blank? or p.user["email"].blank?) ? nil : mail_to(p.user["email"], "#{p.user["first_name"]} #{p.user["last_name"]}", :title => "Project Role: #{p.project_role}")
  end

  def other_studies_flag(involvement)
    unless involvement.subject.involvements == [involvement]
      link_to image_tag('/images/icons/flag_orange.png'), other_involvement_path(involvement), :rel => '#other_studies'
    end
  end
  
  def study_funding_source_info(study)
    funding_sources = study.funding_sources
    if funding_sources.size > 0
      funding_sources.map(&:name).uniq.join(",  ").html_safe
    else
      "N/A"
    end
  end
  
  # Finds an involvement event given a parent involvement and event name
  # 
  # @param [Involvement] involvement parent of the involvement event
  # @param [String] event name of the event to find, case insensitive
  # @return [String, nil] an html span with the event date and note icon (if a note exists). nil if no involvement event found
  def event_info(involvement, event)
    if involvement_event = involvement.involvement_events.detect{|e| e.event.downcase == event.downcase}
      content_tag("span", "#{involvement_event.occurred_on} #{image_tag'/images/icons/note.png' unless involvement_event.note.blank?}".html_safe , :class => event.downcase, :title => event).html_safe
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

  def mrn_and_type_helper(subject)
    mrns = [
      subject.nmff_mrn.blank? ? nil : "NMFF #{subject.nmff_mrn}",
      subject.nmh_mrn.blank? ? nil : "NMH #{subject.nmh_mrn}", 
      subject.ric_mrn.blank? ? nil : "RIC #{subject.ric_mrn}"].compact
    "<span class='mrn bold'>#{mrns.blank? ? 'Not entered/Unknown' : mrns.join(', ')}</span>".html_safe
  end

  def case_number_helper(case_number)
    unless case_number.blank?
      "<span class='case_number bold'>#{case_number}</span>" 
    else
      "<span class='case_number bold'> None Given </span>"
    end.html_safe
  end

  def subject_name_helper(subject, last_name_first=true)
    unless subject.first_name.blank? and subject.last_name.blank?
      if last_name_first
        "<span class='last_name bold'>#{subject.last_name}</span>, <span class='first_name bold'>#{subject.first_name}</span> <span class='middle_name bold'>#{subject.middle_name}</span>"
      else
        "<span class='first_name bold'>#{subject.first_name}</span> <span class='middle_name bold'>#{subject.middle_name}</span> <span class='last_name bold'>#{subject.last_name}</span>"    
      end
    else
      "<span class='last_name bold'> Not entered/Unknown </span>"
    end.html_safe
  end
end
