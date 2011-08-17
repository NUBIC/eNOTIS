class Question < ActiveRecord::Base
  include Surveyor::Models::QuestionMethods

 def default_args
   self.is_mandatory = true if self.is_mandatory.nil?
   self.display_type ||= "default"
   self.pick ||= "none"
   self.display_order ||= self.survey_section ? self.survey_section.questions.count : 0
   self.data_export_identifier ||= Surveyor::Common.normalize(text)
   self.short_text ||= text
 end


  def triggered?(response_set) 
    (self.part_of_group? ? self.question_group.triggered?(response_set) : super)
  end  

  def css_class(response_set)
    if part_of_group?
      [(dependent? ? "dependent" : nil),custom_class].compact.join(" ")

    else
      [(dependent? ? "dependent" : nil), (triggered?(response_set) ? nil : "hidden"), custom_class].compact.join(" ")
    end
  end
end

