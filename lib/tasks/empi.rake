namespace 'subjects' do
  desc "Push eNOTIS subjects to the EMPI"
  task 'empi_upload' => :environment do
    i = Involvement.empi_exportable
    Savon::Request.logger = RAILS_DEFAULT_LOGGER
    Savon::Request.log_level = :info
    Empi::Exporter.new(i).export
  end
end