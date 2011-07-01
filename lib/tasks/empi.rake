namespace 'subjects' do
  desc "Push eNOTIS subjects to the EMPI"
  task 'empi_push' => :environment do
    LOGGER = Logger.new(STDOUT)
    Involvement.empi_eligible.collect(&:id).each do |id|
      begin
        LOGGER.info("Adding [Involvement id:#{id}] to the empi queue")
        Resque.enqueue(EmpiWorker, id) 
      rescue Errno::ECONNREFUSED => e
        LOGGER.info("Failed to add [Involvement id:#{id}] to the empi queue... Please check the resque is started")
      end
    end
  end
end