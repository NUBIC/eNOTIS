class Survey < ActiveRecord::Base
  include Surveyor::Models::SurveyMethods
  has_many :score_configurations
  belongs_to :survey_group
  belongs_to :study

  default_scope :order => "title"
  named_scope :public, :conditions=>["surveys.public is true"]
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
    answers= ["first_name","last_name","case_number","date"]
    sections.collect{|sec| sec.questions}.flatten.collect{|q| q.answers}.flatten.each do |answer|
      answers << "q_#{answer.question.id}_a_#{answer.id}"
    end
    t = Ruport.Table(answers)
    response_sets.each do |response_set|
      result = {"fist_name"=>response_set.involvement.first_name,"last_name"=>response_set.involvement.last_name,"case_number"=>response_set.involvement.case_number}
      #result= involvements.detect{|involvement| involvement.id==response_set.involvement_id}.identifiers
      response_set.responses.each do |response|
        result["q_#{response.question.id}_a_#{response.answer.id}"] = response.to_s 
      end
      t << result
    end
    return t.as(:csv)
  end

  def key_export
    t = Ruport.Table('id','question_data_export_identifier',
                     'question_reference_identifier','question_text',
                     'answer_data_export_identifier','answer_reference_identifier','answer_text')
    qs = sections.collect{|sec| sec.questions}.flatten
    answers =   qs.collect{|q| q.answers}.flatten
    answers.each do |a|
      t << {"id" => "q_#{a.question.id}_a_#{a.id}", 
        'question_data_export_identifier' => a.question.data_export_identifier,
        'question_reference_identifier'=>a.question.reference_identifier,
        'question_text'=>a.question.text,
        'answer_data_export_identifier'=>a.data_export_identifier,
        'answer_reference_identifier'=> a.reference_identifier,
        'answer_text'=>a.text
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

  #def send_access_codes(current_user,params)
  #  involvements = Involvement.with_user_and_study(current_user,self.irb_number)
  #  involvements = involvements.select{|i| params[:recipients].include?(i.id.to_s)}
  #  raise "ASDFsdgdasg" if involvements.empty?
  #  involvements.each do |involvement|
  #    rs = ResponseSet.create(:survey => self, :involvement_id => involvement.id,:effective_date=> Date.today)
  #    Notifier.deliver_access_code(params.merge({:involvement=>involvement,:survey=>self,:response_set=>rs}))
  #  end
  #end

  private
  def associate_study
    self.study = Study.find_by_irb_number(self.irb_number)
  end

end

