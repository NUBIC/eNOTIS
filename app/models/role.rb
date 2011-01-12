class Role < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :study
  belongs_to :study_table
  
  validates_presence_of :netid
  validates_presence_of :study_id
  
  attr_protected :consent_role #defines app permissions

  before_save :truncate_project_role
  
  # Named scopes
  default_scope :order => "project_role"
  
  def last_name
    # TODO fill this in from Bcsec::User
  end
  def can_accrue?
    consent_role == "Obtaining"
  end
  
  def self.update_from_redis
    counters = {:pi_keys => 0, :pi_netids => 0, :pi_roles_created => 0, :pi_errors => 0, :pi_exceptions => 0,
                :co_keys => 0, :co_netids => 0, :co_roles_created => 0, :co_errors => 0, :co_exceptions => 0,
                :ap_keys => 0, :ap_netids => 0, :ap_roles_created => 0, :ap_errors => 0, :ap_exceptions => 0}
    ActiveRecord::Base.connection.execute('truncate roles')
    ActiveRecord::Base.connection.execute('alter sequence authorized_people_id_seq restart with 1')
        
    puts "Principal Investigators"
    project_role = "Principal Investigator"
    consent_role = "Obtaining"
    principal_investigator_list = REDIS.keys 'role:principal_investigators:*'
    counters[:pi_keys] = principal_investigator_list.size
    principal_investigator_list.each do |principal_investigator|
      study  = principal_investigator.split(":")[2]
      netids = REDIS.smembers(principal_investigator)
      counters[:pi_netids] += netids.size
      netids.each do |netid|
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.netid        = UsersToPers.user_lookup(REDIS, study, netid, project_role, consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          if role.save
            counters[:pi_roles_created] += 1
          else
            if role.errors.on(:study_id)=="can't be blank"
              counters[:pi_errors] += 1
              puts "Phantom study: #{study}"
              REDIS.sadd('phantom_studies',study)
              study_keys = REDIS.keys "*#{study}*"
              study_keys.each{|k| REDIS.del k}
            elsif role.errors.on(:study_id) =='has already been taken'
              counters[:pi_errors] += 1
              puts "Study User validation error - Principal Investigator : #{study} - #{netid} - #{project_role} - #{consent_role} "
            end
          end
        rescue Exception    => e
          counters[:pi_exceptions] += 1
          puts "failed to create Authorized Person for study #{study} and user #{netid} #{e}"
        end
      end
    end
    
    puts "Co Investigators"
    project_role = "Co-Investigator"
    consent_role = "Obtaining"
    co_investigator_list = REDIS.keys 'role:co_investigators:*'
    counters[:co_keys] = co_investigator_list.size
    co_investigator_list.each do |co_investigator|
      study  = co_investigator.split(":")[2]
      netids = REDIS.smembers(co_investigator)
      counters[:co_netids] += netids.size
      netids.each do |netid|
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.netid        = UsersToPers.user_lookup(REDIS, study, netid, project_role, consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          if role.save
            counters[:co_roles_created] += 1
          else
            if role.errors.on(:study_id)=="can't be blank"
              counters[:co_errors] += 1
              REDIS.sadd('phantom_studies',study)
              study_keys = REDIS.keys "*#{study}*"
              study_keys.each{|k| REDIS.del k}
            elsif role.errors.on(:study_id) =='has already been taken'
              counters[:co_errors] += 1
              puts "Study User validation error - Co Investigator : #{study} - #{netid} - #{project_role} - #{consent_role} "
              begin
                first_role = role.study.roles.detect{|r| r.netid = role.netid}
                puts "Already listed as #{first_role.project_role} - #{first_role.consent_role}"
              rescue Exception => e
                counters[:co_exceptions] += 1
                puts "Exception Caught"
              end
            end
          end
        rescue Exception    => e
          counters[:co_exceptions] += 1
          puts "failed to create CoInvestigator for study #{study} and user #{netid} #{e}"
        end
      end
    end
    
    puts "Authorized Personnel"
    authorized_personnel_list = REDIS.keys 'role:authorized_personnel:*'
    counters[:ap_keys] = authorized_personnel_list.size
    authorized_personnel_list.each do |authorized_person|
      if (REDIS.type authorized_person) != 'set'
        study, netid = authorized_person.split(':')[2,3]
        counters[:ap_netids] += 1 unless netid.blank?
        project_role = REDIS.hget(authorized_person,'project_role')
        consent_role = REDIS.hget(authorized_person,'consent_role')
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.netid        = UsersToPers.user_lookup(REDIS, study, netid, project_role, consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          if role.save
            counters[:ap_roles_created] += 1
          else
            if role.errors.on(:study_id)=="can't be blank"
              counters[:ap_errors] += 1
              REDIS.sadd('phantom_studies',study)
              study_keys = REDIS.keys "*#{study}*"
              study_keys.each{|k| REDIS.del k}
            elsif role.errors.on(:study_id) == 'has already been taken'
              counters[:ap_errors] += 1
              puts "Study User validation error - Authorized Personnel : #{study} - #{netid} - #{project_role} - #{consent_role} "
              begin
                first_role = role.study.roles.detect{|r| r.netid = role.netid}
                puts "Already listed as #{first_role.project_role} - #{first_role.consent_role}"
              rescue Exception => e
                counters[:ap_exceptions] += 1
                puts "Exception Caught"
              end
            end
            
          end
        rescue Exception    => e
          counters[:ap_exceptions] += 1
          puts "Failed to create Role
          Exception Message: #{e.message}
          Study: #{study} 
          User: #{netid}
          Project Role: #{project_role}
          Consent Role: #{consent_role}"
        end
      end
    end
    puts counters.inspect
    logger.info counters.inspect
  end

  private
  def self.user_lookup(redis, study, netid, project_role, consent_role)
    logger.warn "user_lookup deprecated!"
    UsersToPers.user_lookup(redis, study, netid, project_role, consent_role)
    # if (user= User.find_by_netid(netid))
    #   user
    # elsif(user2=User.find_by_netid(netid.downcase))
    #   user2
    # elsif(user3 = User.find_by_netid(redis.hget("role:user_aliases", netid)))
    #   user3
    # elsif(user4 = User.find_by_netid(redis.hget("role:user_aliases", netid.downcase)))
    #   user4
    # else
    #   puts "Missing Netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
    #   Resque.enqueue(IncompleteRoleProcessor, study, netid, project_role, consent_role)
    #   nil
    # end
  end
  
  # Fix for authorized personnel entry for study STU00005280
  # Project role is way to long. This should go away
  # once the new irb intake form goes live
  def truncate_project_role
    if self.project_role && self.project_role.length > 255
      self.project_role = self.project_role[0..250] + "..."
    end
  end
end
