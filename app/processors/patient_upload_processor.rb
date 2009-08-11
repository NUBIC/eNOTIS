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
        result = InvolvementEvent.add(format_params(r,@study.irb_number))
        if result
          @summary[:success] +=1
          temp_stream << r.fields + ["Success"]
        end
      end
    end
    @study_upload.summary = "#{@summary[:success]}/#{@summary[:total]} Successfully Uploaded"
    @study_upload.result = temp_file
    temp_file.close!
    @study_upload.save
  end

  private

  def validate_row_data(row)
     errors = InvolvementEvent.sanity_check(row)
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


  def format_params(params,irb_number)
   result = {}
   result[:study] = {:irb_number=>irb_number}
   result[:subject] = get_subject(params)
   result[:involvement] = {}
   result[:involvement][:race_type_ids] = get_races(params)
   result[:involvement][:ethnicity_type_id] = get_ethnicity(params)
   result[:involvement][:gender_type_id]=get_gender(params)
   result[:involvement_events] = get_events(params)
   return result
  end
  
  def get_ethnicity(params)
    DictionaryTerm.find(:first,:conditions=>["category= ?and term like ?","Ethnicity",params[:ethnicity]+'%']).id
  end
  def get_gender(params)
    DictionaryTerm.find(:first,:conditions=>["category= ?and term like ?","Gender",params[:gender]+'%']).id
  end


  def get_events(params)
    events =[]
    params.headers.select{|key| key.to_s =~/event_type/i}.each do |key|
      event={}
      event[:event_type_id]  = DictionaryTerm.find(:first,:conditions=>["category= ?and term like ?","Event",params[key]+'%']).id
      event[:occured_at] = Chronic.parse(params[key.to_s.gsub("type","date").to_sym])
      events << event
    end
    return events
  end
  def get_subject(params)
    subject = {}
    subject[:mrn] = params[:mrn]
    subject[:first_name] = params[:first_name]
    subject[:last_name] = params[:last_name]
    subject[:birth_date] = params[:last_name]
    return subject
  end
  def get_races(params)
    races = []
    params.headers.select{|key| key.to_s =~/Race/i}.each do |key|
      races << DictionaryTerm.find(:first,:conditions=>["category= ?and term like ?","Race",params[key]+'%']).id
    end
    return races
  end

end
