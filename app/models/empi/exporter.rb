class Empi::Exporter
  def initialize(involvements, opts={})
    @involvements = [*involvements]
    opts ||= {}
    @verbose = opts[:verbose] || false
  end
  
  def export
    info "Uploading #{@involvements.size} subjects to the EMPI"
    @involvements.each do |inv|
      export_single(inv)
    end
  end
  
  def export_single(involvement)
    Empi.connect(EMPI_SERVICE[:uri], EMPI_SERVICE[:credentials]) unless Empi.client # The unless clause prevents opening new connections
      study = involvement.study
      subject = involvement.subject
      if study.read_only?
        info("[EMPI] #{Time.now} Not uploading read only study #{study.irb_number}")
      else
        info("[EMPI] #{Time.now} Uploading subject #{subject.id} on study #{study.irb_number}")
        begin
          Empi.put(build_params(involvement))
          subject.update_attribute(:empi_updated_date, Time.now)
          info("[EMPI] #{Time.now} Uploaded subject #{subject.id} on study #{study.irb_number}")
        rescue => e
          info("[EMPI] Warning: could not upload [Involvement id: #{involvement.id}]", e)
        end
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
  
  def info(msg, e = nil)
    msg += ": #{e}\n#{e.backtrace.join("\n")}" if e
    ActiveRecord::Base.logger.info(msg) if defined?(ActiveRecord::Base)
    puts msg if @verbose
  end
end