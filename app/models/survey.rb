class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods
  has_many :score_configurations
  belongs_to :survey_group
  belongs_to :study

  default_scope :order => "title"
  named_scope :public, :conditions=>["surveys.is_public is true"]
  accepts_nested_attributes_for :score_configurations

  before_create :associate_study

  def title=(value)
    write_attribute(:title, value)
    adjusted_value = value
    if self.access_code.blank?
      while Survey.find_by_access_code(Survey.to_normalized_string(adjusted_value))
        i ||= 0
        i += 1
        adjusted_value = "#{value} #{i.to_s}"
      end
      self.access_code = Survey.to_normalized_string(adjusted_value)
    end
  end

  def data_export(params)
    #need to add participant attributes to the answers table
    answers= ["first_name","last_name","case_number","nmh_mrn","ric_mrn","nmff_mrn","date"]
    answers += self.sections.collect{|sec| sec.questions}.flatten.collect{|q| q.answers}.flatten.collect{|a| a.id.to_s}.flatten
    t = Ruport.Table(answers)
    response_sets.each do |response_set|
      result = {"fist_name"=>response_set.involvement.first_name,"last_name"=>response_set.involvement.last_name,"case_number"=>response_set.involvement.case_number,
               "ric_mrn"=> response_set.involvement.subject.ric_mrn,"nmh_mrn"=>response_set.involvement.subject.nmh_mrn,"nmff_mrn"=>response_set.involvement.subject.nmff_mrn}
      response_set.responses.each do |response|
        result[response.answer.id.to_s] = response.to_s
      end
      t << result
    end
    return t.as(:csv)
  end

  def key_export
    t = Ruport.Table('id','question_data_export_identifier',
                     'question_reference_identifier','question_text',
                     'answer_data_export_identifier','answer_reference_identifier','answer_text','answer_weight')
    answers = self.sections.collect{|sec| sec.questions}.flatten.collect{|q| q.answers}.flatten
    answers.each do |a|
      t << {"id" => a.id.to_s, 
        'question_data_export_identifier' => a.question.data_export_identifier,
        'question_reference_identifier'=>a.question.reference_identifier,
        'question_text'=>a.question.text,
        'answer_data_export_identifier'=>a.data_export_identifier,
        'answer_reference_identifier'=> a.reference_identifier,
        'answer_text'=>a.text,
        'answer_weight'=>a.weight
           }
    end
    return t.as(:csv)
  end

  def score_export(params)
    headers = ["first_name","last_name","case_number","date"]
    headers << score_configurations.collect{|sc| sc.name}
    t = Ruport.Table(headers.flatten!)
    response_sets.each do |response_set|
      #score_hash= involvements.detect{|involvement| involvement.id==response_set.involvement_id}.identifiers
      score_hash = {"fist_name"=>response_set.involvement.first_name,"last_name"=>response_set.involvement.last_name,"case_number"=>response_set.involvement.case_number}
      score_hash.merge!({"date"=>response_set.completed_at.to_date})
      response_set.scores.each do  |score|
        score_hash.merge!({score.score_configuration.name=>score.value})
      end
      t << score_hash
    end
    return t.as(:csv)
  end

  private
  def associate_study
    self.study = Study.find_by_irb_number(self.irb_number)
  end

end

