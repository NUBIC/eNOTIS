require 'chronic'
class PatientUploadProcessor < ApplicationProcessor

  subscribes_to :patient_upload

  def on_message(message)
    @study_upload = StudyUpload.find(message)
    file_path = @study_upload.upload.path
    temp_file = Paperclip::Tempfile.new("results.csv")
    #find study for upload
    @study = Study.find(@study_upload.study_id)
    @study.save
    logger.debug "received message for study: " + @study.irb_number 
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
    @summary =  {:total=>0,:success=>0}
      FasterCSV.foreach(file_path,:headers => :first_row,:write_headers=>false,:return_headers => false,:header_converters=>:symbol) do |r|
        @summary[:total] +=1
       logger.debug "processing row"
        errors = validate_row_data(r)
        if !errors.empty?
          logger.debug "found error: " +errors.join(". ")
          temp_stream << r.fields +  ["Failed"] +[errors.join(". ")] 
          next
        end
        subject_result = get_upload_patient(r)
        subject = subject_result[:subject]
        if subject.nil?
          temp_stream << r.fields + ["Failed"] + [subject_result[:comments]]
        else
          subject.save
          involvement = find_or_create_involvement(@study.id,subject.id,r)
          create_events(involvement,r)
          @summary[:success] +=1
          temp_stream << r.fields + ["Success"] + [subject_result[:comments]]
        end
      end
    end
    @study_upload.summary = "#{@summary[:success]}/#{@summary[:total]} Successfully Uploaded"
    @study_upload.result = temp_file
    temp_file.close!
    @study_upload.save
  end


  def get_upload_patient(r)
    #retuns a patient plus comments
    @result = {:subject=>nil,:comments=>nil}
    if !r[:mrn].blank?
      @subject = find_by_mrn(r[:mrn])
      @result[:subject]=@subject unless @subject.nil?
      @result[:comments]="unkown mrn" if @subject.nil?
    end
    if !r[:first_name].blank? and !r[:last_name].blank? and !r[:birth_date].blank? and @result[:subject].nil?
      subjects = find_by_attributes(r)
      if subjects.size == 1
        @subject = find_by_mrn(subjects.first.mrn)#Subject.find(:first,:conditions=>["mrn='#{subjects.first.mrn}'"],:span=>:global)
        @result[:subject]=@subject
      elsif subjects.size == 0
        @subject = create_subject(r)
        @result  =  {:subject=>@subject,:comments=>"created new patient"}
      else
        @subject = create_subject(r) #Subject.new({:mrn=>r[:mrn],:birth_date=>r[:birth_date],:first_name=>r[:first_name],:first_name=>r[:first_name]})
        return {:subject=>@subject,:comments=>"multiple edw patients found"}
      end
    end
    return @result
  end

  private


  def create_events(involvement,params)
    event_keys = params.headers.select{|key| key.to_s =~/event_type/i}
    event_keys.each do |key|
      values = {}
      values[:event_type_id]= DictionaryTerm.find(:first,:conditions=>["category= ?and term like ?","Event",params[key]+'%']).id
      #find the corresponding date for given event_type
      values[:occured_at] = Chronic.parse(params[key.to_s.gsub("type","date").to_sym])
      involvement.involvement_events.create(values)
    end
  end

  def validate_row_data(row)
     errors = validate_presence_of_params(row)
     #if any parameters are missing, quite now
     return errors unless errors.empty?
     #check validity of parameters parameters for race, events 
     errors << validate_gender(row)
     errors << validate_ethnicity(row)
     errors << validate_races(row)
     errors << validate_events(row)
     return errors.flatten
  end


  def validate_gender(params)
    genders = DictionaryTerm.find(:all,:conditions=>["category= ?and term like ?","Gender",params[:gender]+'%'])
    (genders.size == 1)? [] :  "Unkown Gender  value: #{params[:gender]}"
  
  end

  def validate_ethnicity(params)
    ethnicities = DictionaryTerm.find(:all,:conditions=>["category= ?and term like ?","Ethnicity",params[:ethnicity]+'%'])
    (ethnicities.size == 1)? [] :  "Unkown ethnicity value: #{params[:ethnicity]}"
  end


  def validate_races(params)
    errors = []
    race_keys = params.headers.select{|key| key.to_s =~/Race/i }
    race_keys.each do |key|
      races = DictionaryTerm.find(:all,:conditions=>["category= ?and term like ?","Race",params[key]+'%'])
      errors <<  "Unkown Race Value: #{params[key]}" unless races.size == 1
    end
    return errors
  end

  def validate_events(params)
    errors = []
    event_keys = params.headers.select{|key| key.to_s =~/event_type/i}
    event_keys.each do |key|
      events = DictionaryTerm.find(:all,:conditions=>["category= ?and term like ?","Event",params[key]+'%'])
      errors <<  "Unkown Event Type: #{params[key]}" unless events.size == 1
    end
    return errors
  end


  def validate_presence_of_params(params)
    errors = []
    if params[:mrn].blank?
      if params[:first_name].blank? and params[:last_name].blank? and Chronic(params[:birth_date]).nil?
        errors << "We require an MRN OR first name, last name and Date of Birth"
      end
    end
    errors << "Race is a required field" unless !params[:race].blank?
    errors << "Gender AND Ethnicity are required fields" if params[:gender].blank? or params[:ethnicity].blank?
    errors << "Event AND corresponding Date are required fields" if params[:event_type].blank? or Chronic.parse(params[:event_date]).nil?
    return errors
  end


  def find_or_create_involvement(study_id,subject_id,values)
    @involvement = Involvement.find(:first,:conditions=>"subject_id=#{subject_id} and study_id=#{study_id}") 
    if @involvement.nil?
     @params={:study_id=>study_id,:subject_id=>subject_id}
     @params[:study_id] = study_id
     @params[:subject_id] = subject_id
     @params[:gender_type_id] = DictionaryTerm.find(:first,:conditions=>["category= ?and term like ?","Gender",values[:gender]]).id
     @params[:ethnicity_type_id] = DictionaryTerm.find(:first,:conditions=>["category= ?and term like ?","Ethnicity",values[:ethnicity]+'%']).id
     @involvement = Involvement.create(@params)
    end
  end
  def find_by_mrn(mrn)
    Subject.find(:first,:conditions=>["mrn='#{mrn}'"],:span=>:global)
  end

  def find_by_attributes(r)
    subjects = Subject.find(:all,:conditions=>["first_name = #{r[:first_name]} and last_name = #{r[:last_name]} and birth_date=#{r[:birth_date]}"],:span=>:foreign)
  end

  def create_subject(r)
    Subject.new({:mrn=>r[:mrn],:birth_date=>r[:birth_date],:first_name=>r[:first_name],:last_name=>r[:last_name]})
  end

end
