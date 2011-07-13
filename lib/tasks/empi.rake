namespace 'subjects' do
  desc "Push eNOTIS subjects to the EMPI"
  task 'empi_upload' => :environment do
    v = %w(true yes on).include?(ENV['VERBOSE'])
    i = Involvement.empi_exportable
    Empi::Exporter.new(i, :verbose => v).export
  end
end