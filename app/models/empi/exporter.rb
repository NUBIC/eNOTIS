class Empi::Exporter
  def initialize(involvements)
    @involvements = [*involvements]
  end
  
  def export
    @involvements.each do |inv|
      export_single(inv)
    end
  end
  
  def export_single(involvement)
    begin
      study = involvement.study
      subject = involvement.subject
      if study.read_only?
        info("[EMPI] #{Time.now} Not uploading read only study #{study.irb_number}")
      else
        info("[EMPI] #{Time.now} Started uploading subject #{subject.id} on study #{study.irb_number}")
        client.put(build_params(involvement))
        subject.update_attribute(:empi_updated_date, Time.now)
        info("[EMPI] #{Time.now} Successfully uploaded subject #{subject.id} on study #{study.irb_number}")
      end
    rescue => e
      info("[EMPI] Warning: could not load [Involvement id: #{involvement.id}]", e)
    end
  end
  
  def build_params(involvement)
    subject = involvement.subject
    
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
  end
  
  def client
    @client ||= Empi.connect(EMPI_SERVICE[:uri], EMPI_SERVICE[:credentials])
  end
  
  def info(msg, e = nil)
    msg += ": #{e}" if e
    ActiveRecord::Base.logger.info(msg) if defined?(ActiveRecord::Base)
  end
end