require 'chronic'
class PatientUploadProcessor < ApplicationProcessor

  subscribes_to :patient_upload

  def on_message(message)
    @study_upload = StudyUpload.find(message)
    file_path = @study_upload.upload.path
    temp_file = Paperclip::Tempfile.new("results.csv")
    @study = Study.find(@study_upload.study_id)
    @study.save
    FasterCSV.open(temp_file.path, "r+") do |temp_stream|
    @summary =  {:total=>0,:success=>0}
      FasterCSV.foreach(file_path,:headers => :first_row,:write_headers=>false,:return_headers => false,:header_converters=>:symbol) do |r|
        @summary[:total] +=1
        subject_result = get_upload_patient(r)
        subject = subject_result[:subject]
        if subject.nil?
          temp_stream << r.fields + ["Failed"] + [subject_result[:comments]]
        else
          subject.save
          involvement = find_or_create_involvement({:study_id=>@study.id,:subject_id=>subject.id})
          involvement.involvement_events.create({:event_type=>r[:subject_event_type].to_s,:event_date=>Chronic.parse(r[:subject_event_date])}).save
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

  def find_or_create_involvement(values)
    Involvement.find(:first,:conditions=>"subject_id=#{values[:subject_id]} and study_id=#{values[:study_id]}") || Involvement.create(:subject_id=>values[:subject_id],:study_id=>values[:study_id])
  end
  def find_by_mrn(mrn)
    Subject.find(:first,:conditions=>["mrn='#{mrn}'"],:span=>:global)
  end

  def find_by_attributes(r)
    subjects = Subject.find(:all,:conditions=>["first_name = #{r[:first_name]} and last_name = #{r[:last_name]} and birth_date=#{r[:birth_date]}"],:span=>:foreign)
  end

  def create_subject(r)
    Subject.new({:mrn=>r[:mrn],:birth_date=>r[:birth_date],:first_name=>r[:first_name],:first_name=>r[:first_name]})
  end
  

end
