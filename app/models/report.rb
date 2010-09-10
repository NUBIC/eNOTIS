#This is a class for exporting data

class Report
  def self.nih_accrual_report(irb_number)
    study = Study.find_by_irb_number(irb_number)
  end
  def self.export(params)
    study       = Study.find_by_irb_number(params[:study][:irb_number])
    involvement = params[:involvement] || {}
    event       = params[:event] || {}
    
    report_header = [].tap do |columns|
      if params[:subject]
        columns << "MRN" if params[:subject].include?("mrn")
      end
      if params[:involvement] && params[:involvement][:attributes]
        columns << "Case Number" if params[:involvement][:attributes].include?("case_number")
      end
      if params[:subject]
        columns << "Last Name"  if params[:subject].include?("last_name")
        columns << "First Name" if params[:subject].include?("first_name")
        columns << "Birth Date" if params[:subject].include?("birth_date")
      end
      if params[:involvement]
        if params[:involvement][:attributes]
          columns << "Gender"    if params[:involvement][:attributes].include?("gender")
          columns << "Ethnicity" if params[:involvement][:attributes].include?("ethnicity")
        end
        if params[:involvement][:methods] 
          columns << "Races" if params[:involvement][:methods].include?("race_as_str")
        end
      end
      if params[:event] && params[:event][:attributes]
        columns << "Event Type" if params[:event][:attributes].include?("event")
        columns << "Event Date" if params[:event][:attributes].include?("occurred_on")
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
          }, 
          :involvement_events => {
            :only => event[:attributes] || [],
            :methods => event[:methods] || []
          }
        }
    )
    
    #properly name columns
    report.rename_columns(
       "involvement_events.event"=>"Event Type",
       "involvement_events.occurred_on"=>"Event Date",
       "case_number"=> "Case Number",
       "subject.mrn" =>"MRN",
           "subject.first_name"=>"First Name",
       "subject.last_name"=>"Last Name",
       "subject.birth_date"=>"Birth Date",
       "race_as_str"=>"Races",
       "gender"=>"Gender",
       "ethnicity"=>"Ethnicity"
    )
    #Data Order
    report.reorder(report_header)
    report.as(params[:format].to_sym)
  end
 
end

