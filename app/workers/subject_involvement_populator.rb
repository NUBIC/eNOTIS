class SubjectInvolvementPopulator
  @queue = :subject_involvement_populator

  def self.perform(redis_key)
    irb_number, patient_id = redis_key.split(":")[0..1]
    subject_hash = HashWithIndifferentAccess.new(REDIS.hgetall("subject:#{redis_key}"))
    params       = HashWithIndifferentAccess.new({
      :subject  => {
        :address_line1 => subject_hash[:address_1],
        :address_line2 => subject_hash[:address_2],
        :address_line3 => subject_hash[:address_3],
        :city          => subject_hash[:city],
        :state         => subject_hash[:state],
        :zip           => subject_hash[:zip],
        :birth_date    => subject_hash[:birth_date],
        :death_date    => subject_hash[:death_date],
        :first_name    => subject_hash[:first_name],
        :last_name     => subject_hash[:last_name],
        :mrn           => subject_hash[:mrn],
        :mrn_type      => subject_hash[:mrn_type],
        :phone_number  => subject_hash[:phone]
      }
    })
    subject = Subject.find_or_create(params)
    study   = Study.find_by_irb_number(irb_number)

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

  def self.calculate_gender(gender)
    case gender
    when "F"
      "Female"
    when "M"
      "Male"
    else
      "Unknown or Not Reported"
    end
  end

  def self.calculate_ethnicity(ethnicity)
    case ethnicity
    when  "Hispanic or Latino"
      "Hispanic or Latino"
    when "Non-Hispanic"
      "Not Hispanic or Latino"
    else
      "Unknown or Not Reported"
    end
  end

  def self.calculate_race(race)
    case race
    when "White"
      { :race_is_white => true }
    when "Black"
      { :race_is_black_or_african_american => true }
    when "Asian"
      { :race_is_asian => true }
    when "Native Hawaiian or Other Pacific Islander"
      { :race_is_native_hawaiian_or_other_pacific_islander => true }
    when "American Indian or Alaska Native"
      { :race_is_american_indian_or_alaska_native => true }
    when "Unknown"
      { :race_is_unknown_or_not_reported => true }
    when "Placeholder"
      { :race_is_unknown_or_not_reported => true }
    end
  end
end