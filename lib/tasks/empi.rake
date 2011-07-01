namespace 'subjects' do
  desc "Push eNOTIS subjects to the EMPI"
  task 'empi_push' => :environment do
    Involvement.empi_eligible.collect(&:id).each do |id|
      begin
        puts "Adding [Involvement id:#{id}] to the empi queue"
        Resque.enqueue(EmpiWorker, id) 
      rescue Errno::ECONNREFUSED => e
        puts "Failed to add [Involvement id:#{id}] to the empi queue... Please check the resque is started"
      end
    end
  end
end