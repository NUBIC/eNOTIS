require 'webservices/edw'

class AuthorizedPersonnelPopulatorEdw
  @queue = :redis_authorized_personnel_populator
  Resque.before_perform_jobs_per_fork do
    Edw.connect
  end

  def self.perform(irb_number, force=false)
    start_time = Time.now
    
    # Find Principal Investigators
    principal_investigators = Edw.find_principal_investigators({:irb_number => irb_number})
    principal_investigators.delete_if{|x| x.values.uniq==[""]}.each do |principal_investigator|
      netid = principal_investigator[:netid]
      if netid==""
        Resque.enqueue(MissingNetidProcessor, irb_number, 'Principal Investigator', 'Obtaining')
      else
        pi_key = "role:principal_investigators:#{irb_number}"
        REDIS.sadd(pi_key,netid)
        Resque.enqueue(Ldapper, irb_number, netid, 'Principal Investigator', 'Obtaining', 'pi')
      end
    end
    
    # Find CoInvestigators
    co_investigators =  Edw.find_co_investigators({:irb_number => irb_number})
    co_investigators.delete_if{|x| x.values.uniq==[""]}.each do |coi|
      netid = coi[:netid]
      if netid==""
        Resque.enqueue(MissingNetidProcessor, irb_number, 'Co-Investigator', 'Obtaining')
      else
        co_investigator_key = "role:co_investigators:#{irb_number}"
        REDIS.sadd(co_investigator_key,netid)
        Resque.enqueue(Ldapper, irb_number, netid, 'Co-Investigator', 'Obtaining', 'coi')
      end
    end
    
    # Find Authorized Personnel
    authorized_people = Edw.find_authorized_personnel({:irb_number => irb_number})
    
    # Cut out duplication by removing the netids of the principal investigators and the co investigators
    priveleged_netids =  principal_investigators.map{|x| x[:netid]}.compact + co_investigators.map{|x| x[:netid]}.compact
    authorized_people.reject!{|person| priveleged_netids.include? person[:netid]}
    
    # Remove any blank entries if everything in the authorized personnel list is blank
    authorized_people.delete_if{|x| x.values.uniq==[""]}.each do |authorized_person|
      
      # If someone doesnt have a netid... 
      if authorized_person[:netid].blank?   
        Resque.enqueue(MissingNetidProcessor, irb_number, 'Co-Investigator', 'Obtaining')
        puts "Missing NetID for #{irb_number} #{authorized_person[:project_role]}, #{authorized_person[:consent_role]}"
      else
        ap_key = "role:authorized_people:#{irb_number}"
        REDIS.sadd(ap_key,authorized_person[:netid])
        Resque.enqueue(Ldapper, irb_number, authorized_person[:netid], authorized_person[:project_role], authorized_person[:consent_role], 'authorized_personnel')
      end
    end
    end_time = Time.now
    puts "#{end_time}: Imported Roles for study # #{irb_number} in #{end_time - start_time} seconds"
  end
end
