class RakeWorker
  @queue = :rake_worker
  def self.perform(job)
    Rake::Task[job].invoke    
  end
end