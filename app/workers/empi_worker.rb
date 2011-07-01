class EmpiWorker
  @queue=:empi
  def self.perform(involvement_id)
    Empi.connect EMPI_SERVICE[:uri], EMPI_SERVICE[:credentials]
    begin
      involvement = Involvement.find(involvement_id)
      study = involvement.study
      if study.read_only?
        info("[EMPI] #{Time.now} Not uploading read only study #{study.irb_number}")
      else
        subject = involvement.subject
        info("[EMPI] #{Time.now} I'd be uploading subject #{subject.id} on study #{study.irb_number}")
        # Upload the subject and involvement info to the EMPI
        params = {
          :source                       => "eNOTIS", 
          :unique_id                    => subject.id.to_s,
          :first_name                   => subject.first_name,
          :middle_name                  => subject.middle_name, 
          :last_name                    => subject.last_name,
          :primary_street_address_1     => involvement.address_line1,
          :primary_street_address_2     => involvement.address_line2,
          :primary_city                 => involvement.city,
          :primary_state                => involvement.state,
          :primary_zip_code             => involvement.zip.to_s,
          :gender                       => involvement.gender, 
          :date_of_birth                => subject.birth_date.to_s,
          :record_creation_date         => subject.created_at.to_s,
          :primes_medical_record_number => subject.nmh_mrn.to_s,
          :idx_medical_record_number    => subject.nmff_mrn.to_s
          }
        Empi.put(params)
        subject.update_attribute(:empi_updated_date, Time.now)
      end
    rescue => e
      info("[EMPI] Warning: could not load [Involvement id: #{involvement_id}]")
    end
  end
  
  def self.info(msg)
    ActiveRecord::Base.logger.info(msg) if defined?(ActiveRecord::Base)
    puts(msg)
  end
end