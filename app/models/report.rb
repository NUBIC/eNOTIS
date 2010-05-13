#This is a class for exporting data

class Report

  def self.export(params)
    study = Study.find_by_irb_number(params[:study][:irb_number])
    involvement = params[:involvement] || {}
    event = params[:event] || {}
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
    report.reorder("MRN","Case Number","Last Name","First Name","Birth Date","Gender","Ethnicity","Races","Event Type","Event Date")
    report.as(params[:format].to_sym)
  end
 
end

