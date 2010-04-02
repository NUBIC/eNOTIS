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
        description_hash = Eirb.find_description({:irb_number=>irb_number})[0]
        if description_hash
          r.hset(study_key, "description",  description_hash[:description])
        end
        inclusion_exclusion_hash = Eirb.find_inc_excl({:irb_number=>irb_number})[0]
        if inclusion_exclusion_hash
          r.hset(study_key, "population_protocol_page",  inclusion_exclusion_hash[:population_protocol_page])
          r.hset(study_key, "exclusion_criteria",  inclusion_exclusion_hash[:exclusion_criteria])
          r.hset(study_key, "inclusion_criteria",  inclusion_exclusion_hash[:inclusion_criteria])
        end
      end
    end
    end_time = Time.now
    puts "Finished Imported #{study_key} in #{end_time - start_time} seconds"
  end
end