require 'webservices/eirb'

class StudyPopulator
  @queue = :redis_study_populator
  Resque.before_perform_jobs_per_fork do
    Eirb.connect
  end
  
  def self.perform(irb_number, force=false)
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis = Redis::Namespace.new('eNOTIS', :redis => Redis.new(config))
    start_time = Time.now
    study_key  = "study:#{irb_number}"
    if force==true
      puts "Forced importing #{study_key}"
      import(irb_number,redis,study_key)
    else
      import(irb_number,redis,study_key) unless redis.exists(study_key)
    end
    end_time = Time.now
    puts "#{end_time}: Imported #{study_key} in #{end_time - start_time} seconds"
  end
  
  def self.import(irb_number,redis,study_key)
    basic_start_time = Time.now
    study_hash = HashWithIndifferentAccess.new(Eirb.find_basics(:irb_number=>irb_number)[0])
    basic_end_time = Time.now
    if study_hash.blank?
      puts "Study #{irb_number} not found in the IRB"
    elsif !study_hash.blank? && study_hash[:irb_status] == 'Exempt Approved'
      puts "Blocking Exempt Approved Study: #{irb_number}"
    else
      puts "#{basic_end_time}: Imported #{study_key} study basics in #{basic_end_time - basic_start_time} seconds"
      study_hash.each do |k,v|
        redis.hset(study_key,k,v)
      end
      
      desc_start_time = Time.now
      description_hash = Eirb.find_description({:irb_number=>irb_number})[0]
      if description_hash
        redis.hset(study_key, "description",  description_hash[:description])
      end
      desc_end_time = Time.now
      puts "#{desc_end_time}: Imported #{study_key} description in #{desc_end_time - desc_start_time} seconds"
      
      inc_exc_start_time = Time.now
      inclusion_exclusion_hash = Eirb.find_inc_excl({:irb_number=>irb_number})[0]
      if inclusion_exclusion_hash
        redis.hset(study_key, "population_protocol_page",  inclusion_exclusion_hash[:population_protocol_page])
        redis.hset(study_key, "exclusion_criteria",  inclusion_exclusion_hash[:exclusion_criteria])
        redis.hset(study_key, "inclusion_criteria",  inclusion_exclusion_hash[:inclusion_criteria])
      end
      inc_exc_end_time = Time.now
      puts "#{inc_exc_end_time}: Imported #{study_key} inclusion/exclusion in #{inc_exc_end_time - inc_exc_start_time} seconds"
      
      funding_source_hashes =  Eirb.find_funding_sources({:irb_number=>irb_number})
      if funding_source_hashes && !funding_source_hashes.blank?
        funding_source_hashes.each_with_index do |fsh,i|
          fsh.each do |k,v|
            redis.hset("#{study_key}:funding_source:#{i}",k,v)
          end
        end
      end
      
    end
  
  end
end
