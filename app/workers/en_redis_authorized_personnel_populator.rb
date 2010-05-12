require 'webservices/edw'

class ENRedisAuthorizedPersonnelPopulator
  @queue = :redis_authorized_personnel_populator
  Resque.before_perform_jobs_per_fork do
    Edw.connect
  end

  def self.perform(irb_number, force=false)
    start_time = Time.now
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis = Redis::Namespace.new('eNOTIS:role', :redis => Redis.new(config))
    principal_investigators = Edw.find_principal_investigators({:irb_number => irb_number})
    principal_investigators.delete_if{|x| x.values.uniq==[""]}.each do |principal_investigator|
      netid = principal_investigator[:netid]
      if netid==""
        Resque.enqueue(EnRedisMissingNetid, irb_number, 'Principal Investigator', 'Obtaining')
      else
        pi_key = "principal_investigators:#{irb_number}"
        redis.sadd(pi_key,netid)
        Resque.enqueue(ENRedisLdapper, irb_number, netid, 'Principal Investigator', 'Obtaining')
      end
    end
    co_investigators =  Edw.find_co_investigators({:irb_number => irb_number})
    co_investigators.delete_if{|x| x.values.uniq==[""]}.each do |coi|
      netid = coi[:netid]
      if netid==""
        Resque.enqueue(EnRedisMissingNetid, irb_number, 'Co-Investigator', 'Obtaining')
      else
        co_investigator_key = "co_investigators:#{irb_number}"
        redis.sadd(co_investigator_key,netid)
        Resque.enqueue(ENRedisLdapper, irb_number, netid, 'Co-Investigator', 'Obtaining')
      end
    end
    priveleged_netids =  principal_investigators.map{|x| x[:netid]}.compact + co_investigators.map{|x| x[:netid]}.compact
    authorized_people = Edw.find_authorized_personnel({:irb_number => irb_number})
    authorized_people.reject!{|person| priveleged_netids.include? person[:netid]}
    authorized_people.delete_if{|x| x.values.uniq==[""]}.each do |authorized_person|
      if authorized_person[:netid]==""
        Resque.enqueue(EnRedisMissingNetid, irb_number, 'Co-Investigator', 'Obtaining')
        puts "Missing NetID for #{irb_number} #{authorized_person[:project_role]}, #{authorized_person[:consent_role]}"
      else
        ap_key = "authorized_personnel:#{irb_number}"
        redis.sadd(ap_key,authorized_person[:netid])
        Resque.enqueue(ENRedisLdapper, irb_number, authorized_person[:netid], authorized_person[:project_role], authorized_person[:consent_role])
      end
    end
    end_time = Time.now
    puts "#{end_time}: Imported Roles for study # #{irb_number} in #{end_time - start_time} seconds"
  end
end