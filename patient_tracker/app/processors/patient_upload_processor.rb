require 'chronic'
class PatientUploadProcessor < ApplicationProcessor

  subscribes_to :patient_upload

  def on_message(message)
    #logger.debug "PatientUploadProcessor received: " + message
    logger.debug "Patient Upload Processor received study_upload request with ID: " + message
    #@irb_number = "STU00001174"
    
    @study_upload = StudyUpload.find(message)
    file_path = @study_upload.upload.path
    logger.debug "file path: "+ file_path
    temp_file = Tempfile.new("results")

    #@study = Study.find(:first,:conditions=>["irb_number= #{irb_number}"],:span=>:global)
    logger.debug "attempting to find study with id: " + @study_upload.study_id.to_s
    @study = Study.find(@study_upload.study_id)
    logger.debug "found study with id: "+ @study.id.to_s
    @study.save
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
      FasterCSV.foreach(file_path,:headers => :first_row,:write_headers=>false,:return_headers => false,:header_converters=>:symbol) do |r|
        subject_result = get_upload_patient(r)
        subject = subject_result[:subject]
        if subject.nil?
          temp_stream << r.fields + ["Failed"] + [subject_result[:comments]]
        else
          subject.save
          involvement = Involvement.find(:first,:conditions=>"subject_id=#{subject.id} and study_id=#{@study.id}") || Involvement.create(:subject_id=>subject.id,:study_id=>@study.id)
          involvement.involvement_events.create(:type=>r[:subject_event_type],:event_date=>Chronic.parse(r[:subject_event_date])).save
          temp_stream << r.fields + ["Success"] + [subject_result[:comments]]
        end
      end
    end
    @study_upload.result = temp_file
    temp_file.close!
    @study_upload.save
  end

  def get_upload_patient(r)
    #retuns a patient plus comments hash
    if !r[:mrn].blank?
      @subject = Subject.find(:first,:conditions=>["mrn='#{r[:mrn]}'"],:span=>:global)
      return {:subject=>@subject} unless @subject.nil?
      return {:subject=>nil,:comments=>"unkown mrn"}
    elsif !r[:first_name].blank? and !r[:last_name].blank? and !r[:birth_date].blank?
      subjects = Subject.find(:all,:conditions=>["first_name = #{r[:first_name]} and last_name = #{r[:last_name]} and birth_date=#{r[:birth_date]}"],:span=>:foreign)
      if subjects.size == 1
        @subject = Subject.find(:first,:conditions=>["mrn='#{subjects.first.mrn}'"],:span=>:global)
        return {:subject=>@subject}
      elsif subjects.size == 0
        @subject = Subject.new({:mrn=>r[:mrn],:birth_date=>r[:birth_date],:first_name=>r[:first_name],:first_name=>r[:first_name]})
        return {:subject=>@subject,:comments=>"created new patient"}
      else
        return {:subject=>nil,:comments=>"multiple edw patients found"}
      end
    else
      return {:subject=>nil,:comments=>"invalid input data"}
    end

  end
end
