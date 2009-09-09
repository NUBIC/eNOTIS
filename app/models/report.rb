#This is a class for exporting data

class Report

  def self.export_subjects(irb_number)
    study = Study.find_by_irb_number(irb_number) 
    report = Involvement.report_table(:all,:only => [],:methods=>[:ethnicity,:gender,:race_list],
    :conditions => {:study_id=>study.id},
    :include =>
    {:subject => {:only =>[ "first_name","last_name","birth_date"]}}

    )
    report.rename_columns("subject.first_name"=>"First Name","subject.last_name"=>"Last Name","subject.birth_date"=>"Birth Date","race_list"=>"Races","gender"=>"Gender","ethnicity"=>"Ethnicity")
    report.as(:csv)
  end

  
end

