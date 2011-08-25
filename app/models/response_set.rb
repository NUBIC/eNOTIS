class ResponseSet < ActiveRecord::Base
  require 'lib/scoring'

  include Surveyor::Models::ResponseSetMethods
  has_many :scores
  belongs_to :involvement

  named_scope :completed, :conditions => ['response_sets.completed_at IS NOT NULL']

    def status
      self.completed_at.nil? ? "Started" : "Completed"
    end

    def first_incomplete_section
      survey.sections.detect{|sec| !section_mandatory_questions_complete?(sec)}
    end


    def complete_with_validation!
      if mandatory_questions_complete? 
        self.completed_at = Time.now
	Scoring.score(self)
	save!
      else
        return false
      end
    end

    def progress_hash
      qs = survey.sections.collect{|s| s.questions.find(:all,:conditions=>["display_type != 'label' and display_type!='image'"])}.flatten!
      triggered = qs.select{|q| q.triggered?(self)}# qs - ds.select{|d| !d.is_met?(self)}.map(&:question)
      { :questions => qs.compact.size,
	             :triggered => triggered.compact.size,
	             :triggered_mandatory => triggered.select{|q| q.mandatory?}.compact.size,
	             :triggered_mandatory_completed => triggered.select{|q| q.mandatory? and is_answered?(q)}.compact.size
	           }
    end
    def section_mandatory_questions_complete?(sec)
      qs = SurveySection.find(sec).questions.find(:all,:conditions=>["display_type != 'label' and display_type!='image'"])
      triggered = qs.select{|q| q.triggered?(self) and q.mandatory?}
      return true if triggered.empty?
      triggered.each{|q| return false unless is_answered?(q)}
      return true
    end
    def section_percentage_complete(section)
      qs = SurveySection.find(section).questions.find(:all,:conditions=>["display_type != 'label' and display_type!='image'"])
      triggered = qs.select{|q| q.triggered?(self)}
      return 100 if triggered.empty?
      answered = triggered.select{|q| is_answered?(q)}.compact.size
      return ((answered.to_f/triggered.size.to_f)*100).to_i
    end

    def next
      survey.survey_group.nil? ? nil : survey.survey_group.next(self)
    end
end
