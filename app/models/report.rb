 # This is a class for exporting data as reports in CSV or PDF 
# It requires that the models it has to report on have been
# extended by Ruport to have additional methods and behavior. 
# Ruport methods are called by this class.

class Report
  
 #  def self.nih_accrual_report(irb_number)
 #    study = Study.find_by_irb_number(irb_number)
 #  end

  # The mapping of User display names to method/attr names in the models involved
  HEADERS = {
  :subject => {
    "First Name" => "first_name",
    "Last Name" => "last_name",
    "Nmff Mrn" => "nmff_mrn",
    "Nmh Mrn" => "nmh_mrn",
    "Birth Date" => "birth_date"
  },
  :involvement => {
    "Case Number" => "case_number",
    "Races" => "race_as_str",
    "Gender" => "gender",
    "Ethnicity" => "ethnicity"
  },
  :event => {
    "Consented" => "consented_report",
    "Completed" => "completed_report",  
    "Withdrawn" => "withdrawn_report" 
  }}

  # The explicit ording for the columns we want to show in the output
  ORDER = ["Case Number", "Nmff Mrn", "Nmh Mrn", "Last Name", "First Name",
    "Birth Date", "Gender", "Ethnicity", "Races", "Consented", "Completed", "Withdrawn"]

  def self.export(params)
    # Setup the data
    study       = Study.find_by_irb_number(params[:study][:irb_number])
    involvement = params[:involvement] || {}
    event       = params[:event] || {}
   
    # Create report
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
        })

    # Correcting column names
    report.rename_columns( self.name_changes )

    # From form params adjusting data based on user selection 
    cols_req = self.filter_columns(params)
    report.reorder(cols_req)

    # Returning the requested format
    format = params[:format].to_sym
    if format==:csv
      report.as(:csv)
    else
      report.as(:pdf, :paper_orientation => :landscape, :table_format=>{:maximum_width=>750})
    end
  end

  # Given the parameters, determine what the report header should look like
  def self.filter_columns(params)
    columns = Array.new(ORDER.count)
    if params[:involvement] 
      if params[:involvement][:attributes]
        # Looking at the chosen involvement attrs
        pa = params[:involvement][:attributes]
        HEADERS[:involvement].each do |k,v|
          columns[ORDER.index(k)] = k if pa.include?(v)
        end
      end
      if params[:involvement][:methods] 
        pm = params[:involvement][:methods]
        HEADERS[:involvement].each do |k,v|
          columns[ORDER.index(k)] = k if pm.include?(v)
        end
        if params[:involvement][:methods].include?("all_events")
          %w(consented completed withdrawn).each do |method_name|
            k = method_name.titleize
            columns[ORDER.index(k)] = k
          end
        end
      end
    end  
    if params[:subject]
      ps = params[:subject]
      HEADERS[:subject].each do |k,v|
        columns[ORDER.index(k)] = k if params[:subject].include?(v)
      end
    end
    columns.compact
  end

  def self.name_changes
    # Correcting names on columns
    changes = {}
    changes.merge! HEADERS[:involvement]
    changes.merge! HEADERS[:event]
    HEADERS[:subject].each do |k,v|
      changes[k] = "subject.#{v}"
    end
    changes.invert
  end

  def self.collapse_headers()
    headers = {}
    HEADERS.each_value do |v|
      headers.merge! v
    end
    headers
  end

end

