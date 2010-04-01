require 'webservices/eirb'

class ENRedisStudyPopulator
  @queue = :redis_study_populator
  def self.perform(irb_number, force=false)
    r = Redis.new
    start_time = Time.now
    study_key = "eNOTIS:study:#{irb_number}"
    unless r.exists(study_key) || force==true
      study_hash = Eirb.find_basics(:irb_number=>irb_number)[0]
      if study_hash
        study_hash.each do |k,v|
          r.hset(study_key,k,v)
        end
      end
    end
    end_time = Time.now
    puts "Imported #{study_key} in #{end_time - start_time} seconds"
  end
end