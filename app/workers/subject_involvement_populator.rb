class SubjectInvolvementPopulator
  @queue = :subject_involvement_populator

  def self.perform(redis_key)
    irb_number, patient_id = redis_key.split(":")[1..2]
    subject_hash = HashWithIndifferentAccess.new(REDIS.hgetall(redis_key))
    params       = HashWithIndifferentAccess.new({
      :subject  => {
        :address_line1       => subject_hash[:address_1],
        :address_line2       => subject_hash[:address_2],
        :address_line3       => subject_hash[:address_3],
        :city                => subject_hash[:city],
        :state               => subject_hash[:state],
        :zip                 => subject_hash[:zip],
        :birth_date          => subject_hash[:birth_date],
        :death_date          => subject_hash[:death_date],
        :first_name          => subject_hash[:first_name],
        :last_name           => subject_hash[:last_name],
        :nmff_mrn             => /NMFF/ =~ subject_hash[:mrn_type] ? subject_hash[:mrn] : nil,
        :nmh_mrn          => /NMH/ =~ subject_hash[:mrn_type] ? subject_hash[:mrn] : nil,
        :phone_number        => subject_hash[:phone],
        :external_patient_id => patient_id,
        :data_source         => "NOTIS" 
      }
    })
    subject = Subject.find_by_external_patient_id(patient_id)
    if subject
      subject.update_attributes(params[:subject])
    else
      subject = Subject.create(params[:subject])
    end
    study = Study.find_by_irb_number(irb_number)

    if study
      unless study.read_only?
        study.read_only!("the NOTIS System")
        study.save
      end

      involvement_params = {
        :subject_id  => subject.id,
        :study_id    => Study.find_by_irb_number(irb_number).id,
        :gender      => calculate_gender(subject_hash[:sex]),
        :case_number => subject_hash[:case_number],
        :ethnicity   => calculate_ethnicity(subject_hash[:ethnicity])
      }.merge(calculate_race(subject_hash[:race]))

      involvement = Involvement.update_or_create(involvement_params)

      if !subject_hash[:withdrawn_date].blank?
        ie = InvolvementEvent.new
        ie.involvement = involvement
        ie.event       = "Withdrawn"
        ie.occurred_on = subject_hash[:withdrawn_date].split("T").join(" ")
        ie.save
      end

      if !subject_hash[:consented_date].blank?
        ie = InvolvementEvent.new
        ie.involvement = involvement
        ie.event       = "Consented"
        ie.occurred_on = subject_hash[:consented_date].split("T").join(" ")
        ie.save
      end

      if !subject_hash[:completed_date].blank?
        ie = InvolvementEvent.new
        ie.involvement = involvement
        ie.event       = "Completed"
        ie.occurred_on = subject_hash[:completed_date].split("T").join(" ")
        ie.save
      end
    else
      REDIS.sadd("missing:study",irb_number)
    end
  end


end
