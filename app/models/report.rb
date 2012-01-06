 # This is a class for exporting data as reports in CSV or PDF
# It requires that the models it has to report on have been
# extended by Ruport to have additional methods and behavior.
# Ruport methods are called by this class.

class Report

  def self.export(params)
    if params[:type].eql?("survey_data")
      return Survey.find(params[:survey_id]).data_export(params)
    elsif params[:type].eql?("survey_key")
      return Survey.find(params[:survey_id]).key_export
    elsif params[:type].eql?("survey_score")
      return Survey.find(params[:survey_id]).score_export(params)
    elsif params[:type].eql?("subjects")
      return subject_export(params)
    end
  end


  def self.subject_export(params)
    study = Study.find_by_irb_number(params[:study][:irb_number])
    report = Involvement.report_table(:all,
        :only => ['id','case_number','ethnicity','gender'],
        :methods =>['first_name','last_name','nmh_mrn','ric_mrn','nmff_mrn','races','birth_date'],
        :conditions => {
          :study_id => study.id
        })
    involvements = study.involvements
    report.add_columns(study.event_types.collect{|et| et.name})
    report.each{|r| i = Involvement.find(r['id']);study.event_types.each{|et| r[et.name]=i.event_dates(et).join(":")}}
    {:report=>report.as(:csv),:name=>'subject_export'}
  end
end

