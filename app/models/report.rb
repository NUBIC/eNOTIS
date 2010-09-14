#This is a class for exporting data

class Report
  def self.nih_accrual_report(irb_number)
    study = Study.find_by_irb_number(irb_number)
  end
  def self.export(params)
    study       = Study.find_by_irb_number(params[:study][:irb_number])
    involvement = params[:involvement] || {}
    event       = params[:event] || {}
    
    # Dynamically create a list of columns based on the checkboxes
    # passed in via the params hash
    # i know what your'e thinking, this code looks ugly, but the array has to be ordered.
    report_header = [].tap do |columns|
      if params[:involvement] && params[:involvement][:attributes]
        columns << "Case Number" if params[:involvement][:attributes].include?("case_number")
      end
      if params[:subject]
        columns << "MRN" if params[:subject].include?("mrn")
        %w(last_name first_name birth_date).each do |method_name|
          columns << method_name.humanize.titleize if params[:subject].include?(method_name)
        end
      end
      if params[:involvement]
        if params[:involvement][:attributes]
          columns << "Gender"    if params[:involvement][:attributes].include?("gender")
          columns << "Ethnicity" if params[:involvement][:attributes].include?("ethnicity")
        end
        if params[:involvement][:methods] 
          columns << "Race" if params[:involvement][:methods].include?("race_as_str")
          if params[:involvement][:methods].include?("all_events")
            %w(consented completed withdrawn).each do |method_name|
              params[:involvement][:methods] << "#{method_name}_report"
              columns << "#{method_name.titleize}"
            end
           end
        end
      end
    end

    #create report
    report = Involvement.report_table(:all,
        :only => involvement[:attributes] || [],
        :methods => involvement[:methods] || [],
        :conditions => {
          :study_id => study.id
        },
        :include => {
          :subject => {
            :only => params[:subject] || []
          }
        }
    )

    #properly name columns
    report.rename_columns(
       "case_number"        =>  "Case Number",
       "subject.mrn"        =>  "MRN",
       "subject.first_name" =>  "First Name",
       "subject.last_name"  =>  "Last Name",
       "subject.birth_date" =>  "Birth Date",
       "race_as_str"        =>  "Races",
       "consented_report"   =>  "Consented",
       "completed_report"   =>  "Completed",
       "withdrawn_report"   =>  "Withdrawn",
       "gender"             =>  "Gender",
       "ethnicity"          =>  "Ethnicity"
    )
    #Data Order
    report.reorder(report_header)
    format = params[:format].to_sym
    if format==:csv
      report.as(:csv)
    else
      report.as(:pdf, :paper_orientation => :landscape, :table_format=>{:maximum_width=>750})
    end
  end
end

