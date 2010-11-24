require 'fastercsv'
require 'chronic'
class StudyUpload < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :study

  # Mixins
  has_attached_file :upload
  has_attached_file :result
  
  # Validators  
  validates_attachment_presence :upload # upload must be present on create, result is added later (update) by processor
  validates_attachment_size :upload, :less_than => 5.megabytes # until we have a good reason to change it
  validates_attachment_size :result, :less_than => 5.megabytes
  
  # Scopes
  default_scope :order => "created_at DESC"
  
  # TODO, try turning these two validations on - yoon
  # validates_attachment_content_type :upload, :content_type => ['text/csv', 'text/plain']
  # validates_attachment_content_type :result, :content_type => ['text/csv', 'text/plain']
  def self.required_columns
    %w(case_number nmff_mrn nmh_mrn ric_mrn last_name first_name birth_date gender ethnicity race consented_on withdrawn_on completed_on)
  end

  def legit?
    upload_exists? && parse_upload && create_subjects
  end
  
  def upload_exists?
    # logger.info "upload exists?"
    self.summary = "Oops. Please upload a file." unless self.upload.valid?
    return self.upload.valid?
  end
  
  def parse_upload
    begin
      # logger.info "parse_upload"
      csv_is_valid = true
      temp_file = Paperclip::Tempfile.new("results.csv")
      FasterCSV.open(temp_file.path, "r+") do |temp_stream|
        FasterCSV.parse(self.upload.to_io, :headers => :first_row, :return_headers => true, :header_converters => :symbol) do |r|
          if r.header_row? # check header row
            return csv_is_valid = false if missing_columns?(r)
            temp_stream << r.fields + ["Result"]
          else # check non-header rows
            if (e = errors_for_row(r)).compact.empty?
              temp_stream << r.fields + ["Ok"]
            else
              temp_stream << r.fields + [e.join(". ")]
              self.summary = "Oops. Your upload had some issues. Please open the result and fix the issues indicated."
              csv_is_valid = false
            end
          end
        end
      end
      self.result = temp_file if !csv_is_valid
      self.result_file_name = self.upload_file_name.gsub(/\.csv$/, '-result.csv')
    rescue #FasterCSV::MalformedCSVError
      csv_is_valid = false
      self.summary = "Oops. Your upload is not a valid CSV file."
    ensure
      temp_file.close!
      self.save
      return csv_is_valid
    end
  end
 
  def create_subjects
    # logger.info "create_subjects"
    subjects_created = 0
    temp_file = Paperclip::Tempfile.new("results2.csv")
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
      FasterCSV.parse(self.upload.to_io, :headers => :first_row, :return_headers => true, :header_converters => :symbol) do |r|
        if r.header_row?
          temp_stream << r.fields + ["Result"]
        else
          if inv = create_subject(r)
            # output translated gender, ethnicity, race
            temp_stream << r.headers.map{|h| [:gender, :ethnicity, :race].include?(h) ? inv.send(h) : r[h]} + ["Created"]
            subjects_created += 1
          else
            temp_stream << r.fields + ["Failed"]
          end

        end
      end
    end
    self.update_attributes(:summary => "#{subjects_created} subjects created.", :result => temp_file, :result_file_name => upload_file_name.gsub(/\.csv$/, '-result.csv'))
    temp_file.close!
    return subjects_created > 0
  end
  
  def create_subject(r)
    Study.transaction do # read http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
      params = params_from_row(r)
      # Subject - create a subject
      subject = Subject.create(params[:subject])
      raise ActiveRecord::Rollback if study.nil? or subject.nil?
      params[:involvement].merge!({:subject_id => subject.id, :study_id => self.study.id})
      
      # Involvement - create an involvement
      involvement = Involvement.update_or_create(params[:involvement])
      raise ActiveRecord::Rollback if involvement.nil? or involvement.id.nil?      
      params[:involvement_events].each{|ie| ie.merge!({:involvement_id => involvement.id}) }

      # logger.info r.inspect
      # logger.info params.inspect
      
      # InvolvementEvent - create the event
      params[:involvement_events].each do |event_params|
        InvolvementEvent.create(event_params)
      end
      involvement
    end
  end
  
  def params_from_row(r)
    { :user => self.user.attributes.symbolize_keys,
      :study => self.study.attributes.symbolize_keys,
      :subject => { :nmff_mrn => r[:nmff_mrn],
                    :nmh_mrn => r[:nmh_mrn],
                    :ric_mrn => r[:ric_mrn],
                    :first_name => r[:first_name], 
                    :last_name => r[:last_name], 
                    :birth_date => r[:birth_date]},
      :involvement => { :case_number => r[:case_number], 
                       :gender => Involvement.translate_gender(r[:gender]),
                       :ethnicity => Involvement.translate_ethnicity(r[:ethnicity]),
                       :race => Involvement.translate_race(r[:race])},
      :involvement_events => %w(consented withdrawn completed).map do |category|
        if (event_date = Chronic.parse(r["#{category}_on".to_sym])).blank?
          nil
        else
          { :occurred_on => event_date.to_date,
            :event_type_id => self.study.event_types.find_by_name(category),
            :note => r["#{category}_note".to_sym]
          }
        end
      end.compact
    }
  end
  
  def missing_columns?(r)
    missing = StudyUpload.required_columns - r.headers.map(&:to_s)
    if missing.empty?
      return false
    else
      self.summary = "Oops. Your upload is missing required columns: #{missing.join(', ')}"
      self.save
      return true
    end
  end

  def errors_for_row(r)
    [check_identity(r)] + check_terms(r) + [check_event_dates(r)]
  end
  
  def check_identity(hash)
    "Either MRN, first name/last name/birth date (with four digit year), or case number are required" if (hash[:nmff_mrn].blank? and hash[:nmh_mrn].blank? and hash[:ric_mrn].blank? and (hash[:first_name].blank? or hash[:last_name].blank? or Chronic.parse(hash[:birth_date]).nil?) and hash[:case_number].blank?)
  end
  
  def check_terms(hash)
    %w(gender ethnicity race).map do |category|
      "#{hash[category.to_sym].blank? ? "Blank #{category.capitalize}" : "Unknown #{category.capitalize}: #{hash[category.to_sym]}"}" unless Involvement.send("translate_#{category}", hash[category.to_sym].to_s)
    end
  end
  
  def check_event_dates(hash)
    "Either consented on, withdrawn on, or completed on is required (with four digit year)" if (Chronic.parse(hash[:consented_on]).blank? and Chronic.parse(hash[:withdrawn_on]).blank? and Chronic.parse(hash[:completed_on]).blank?)
  end

end
