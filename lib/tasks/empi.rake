namespace 'subjects' do
  desc "Push eNOTIS subjects to the EMPI"
  task 'empi_upload' => :environment do
    i = Involvement.empi_exportable
    Empi::Exporter.new(i).export
  end
end