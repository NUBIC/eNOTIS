require 'Chronic'
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
  
  # TODO, try turning these two validations on - yoon
  # validates_attachment_content_type :upload, :content_type => ['text/csv', 'text/plain']
  # validates_attachment_content_type :result, :content_type => ['text/csv', 'text/plain']

  def legit?
    legit = upload_exists? && parse_upload && create_subjects
    puts self.summary
    legit
  end
  def upload_exists?
    self.summary = "No file given, please upload a file." unless self.upload.valid?
    return self.upload.valid?
  end
  def parse_upload
    csv_is_valid = true
    temp_file = Paperclip::Tempfile.new("results.csv")
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
      FasterCSV.parse(self.upload.to_io, :headers => :first_row, :return_headers => true, :header_converters => :symbol) do |r|
        if r.header_row? # check header row
          return false if missing_columns?(r)
        else # check non-header rows
          if (e = errors_for_row(r)).compact.empty?
            temp_stream << r.fields + ["Ok"]
          else
            temp_stream << r.fields + [e.join(". ")]
            self.summary = "There were issues with the file you uploaded. Please open the result and fix the issues indicated."
            csv_is_valid = false
            # puts [r.to_hash.inspect, e.inspect, nil].join("\n")
          end
        end
      end
    end
    self.result = temp_file if !csv_is_valid
    temp_file.close!
    return csv_is_valid
  end
  def create_subjects
    subjects_created = 0
    temp_file = Paperclip::Tempfile.new("results2.csv")
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
      FasterCSV.parse(self.upload.to_io, :headers => :first_row, :return_headers => false, :header_converters => :symbol) do |r|
        puts r.to_hash.inspect
        subjects_created += 1 if create_subject(r)
        puts subjects_created
      end
    end
    self.summary = "#{subjects_created} subjects created."
    return subjects_created == 0 ? false : true
  end
  
  def create_subject(r)
    Study.transaction do # read http://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html
      params = params_from_row(r)
      
      # Subject - find or create a subject
      subject = Subject.find_or_create_for_import(params)
      puts "subject is nil?: #{subject.nil?}"
      raise ActiveRecord::Rollback if study.nil? or subject.nil?
      
      # Involvement - create an involvement
      ip = params[:involvement].merge({:subject_id => subject.id, :study_id => self.study.id})
      involvement = Involvement.update_or_create(params[:involvement].merge({:subject_id => subject.id, :study_id => self.study.id}))
      raise ActiveRecord::Rollback if involvement.nil? or involvement.id.nil?
      
      # InvolvementEvent - create the event
      params[:involvement_events].each do |event|
        InvolvementEvent.find_or_create(event)
      end
    end
  end
  
  def params_from_row(r)
    p = { :user => self.user.attributes.symbolize_keys,
      :study => self.study.attributes.symbolize_keys,
      :subject => { :mrn => r[:mrn], 
                    :first_name => r[:first_name], 
                    :last_name => r[:last_name], 
                    :birth_date => Chronic.parse(r[:birth_date]) },
      :involvement => { :case_number => r[:case_number], 
                       :gender_type_id => DictionaryTerm.gender_id(r[:gender]),
                       :ethnicity_type_id => DictionaryTerm.ethnicity_id(r[:ethnicity]),
                       :race_type_ids => [r[:race], r[:race2]].map{|x| x.blank? ? nil : DictionaryTerm.race_id(x)}.compact
                      },
      :involvement_events => %w(consented withdrawn completed).map do |event_type|
        if (event_date = Chronic.parse(r["#{event_type}_at".to_sym])).blank?
          nil
        else
          { :occurred_on => event_date,
            :event_type_id => DictionaryTerm.event_id(event_type),
            :note => r["#{event_type}_note".to_sym]
          }.merge({:involvement_id => involvement.id})
        end
      end.compact
    }
    # puts p.inspect
    p
  end
  
  def missing_columns?(r)
    missing = %w(case_number mrn first_name last_name birth_date gender race ethnicity consented_on consented_note withdrawn_on withdrawn_note completed_on completed_note) - r.headers.map(&:to_s)
    if missing.empty?
      return false
    else
      self.summary = "The following columns are required: #{missing.join(',')}"
      return true
    end
  end
  def errors_for_row(r)
    [check_identity(r)] + check_terms(r) + [check_event_dates(r)]
  end
  def check_identity(hash)
    "Either MRN, first name/last name/birth date (with four digit year), or case number are required" if (hash[:mrn].blank? and (hash[:first_name].blank? or hash[:last_name].blank? or Chronic.parse(hash[:birth_date]).nil?) and hash[:case_number].blank?)
  end
  def check_terms(hash)
    %w(gender ethnicity race).map do |category|
      "#{hash[category.to_sym].blank? ? "Blank #{category.capitalize}" : "Unknown #{category.capitalize}: #{hash[category.to_sym]}"}" unless DictionaryTerm.send(category.pluralize).include?(hash[category.to_sym].to_s.downcase)
    end
  end
  def check_event_dates(hash)
    "Either consented on, withdrawn on, or completed on is required (with four digit year)" if (Chronic.parse(hash[:consented_on]).blank? and Chronic.parse(hash[:withdrawn_on]).blank? and Chronic.parse(hash[:completed_on]).blank?)
  end
end
