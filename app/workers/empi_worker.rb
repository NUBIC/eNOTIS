class EmpiWorker
  @queue=:empi
  def self.perform(involvement_id)
    Empi.connect EMPI_SERVICE[:uri], EMPI_SERVICE[:credentials]
    involvement = Involvement.find(involvement_id)
    study = involvement.study
    if study.read_only?
      puts "[EMPI] #{Time.now} Not uploading read only study #{study.irb_number}"
    else
      subject = involvement.subject
      puts "[EMPI] #{Time.now} I'd be uploading subject #{subject.id} on study #{study.irb_number}"
      # Upload the subject and involvement info to the EMPI
      params = {
        :source                       => "eNOTIS", 
        :unique_id                    => subject.id.to_s,
        :first_name                   => subject.first_name,
        :middle_name                  => subject.middle_name, 
        :last_name                    => subject.last_name,
        :primary_street_address_1     => subject.address_line1,
        :primary_street_address_2     => subject.address_line2,
        :primary_city                 => subject.city,
        :primary_state                => subject.state,
        :primary_zip_code             => subject.zip.to_s,
        :gender                       => involvement.gender, 
        :date_of_birth                => subject.birth_date.to_s,
        :record_creation_date         => subject.created_at.to_s,
        :primes_medical_record_number => subject.nmh_mrn.to_s,
        :idx_medical_record_number    => subject.nmff_mrn.to_s
        }
      Empi.put(params)
      subject.update_attribute(:empi_updated_date, Time.now)
    end
  end
end