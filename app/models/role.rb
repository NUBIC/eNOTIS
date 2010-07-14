class Role < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :study
  belongs_to :study_table
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  validates_presence_of :user_id
  validates_presence_of :study_id
  
  attr_protected :consent_role #defines app permissions

  before_save :truncate_project_role
  
  def can_accrue?
    consent_role == "Obtaining"
  end
  
  def self.update_from_redis
    ActiveRecord::Base.connection.execute('truncate roles')
    ActiveRecord::Base.connection.execute('alter sequence authorized_people_id_seq restart with 1')
        
    puts "Principal Investigators"
    project_role = "Principal Investigator"
    consent_role = "Obtaining"
    principal_investigator_list = REDIS.keys 'role:principal_investigators:*'
    principal_investigator_list.each do |principal_investigator|
      study  = principal_investigator.split(":")[2]
      netids = REDIS.smembers(principal_investigator)
      netids.each do |netid|
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.user         = user_lookup(REDIS, study, netid, project_role, consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          unless role.save
            if role.errors.on(:study_id)=="can't be blank"
              puts "Phantom study: #{study}"
              REDIS.sadd('phantom_studies',study)
              study_keys = REDIS.keys "*#{study}*"
              study_keys.each{|k| REDIS.del k}
            elsif role.errors.on(:study_id) =='has already been taken'
              puts "Study User validation error - Principal Investigator : #{study} - #{netid} - #{project_role} - #{consent_role} "
            end
          end
        rescue Exception    => e
          puts "failed to create Authorized Person for study #{study} and user #{netid}"
        end
      end
    end
    
    puts "Co Investigators"
    project_role = "Co-Investigator"
    consent_role = "Obtaining"
    co_investigator_list = REDIS.keys 'role:co_investigators:*'
    co_investigator_list.each do |co_investigator|
      study  = co_investigator.split(":")[2]
      netids = REDIS.smembers(co_investigator)
      netids.each do |netid|
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.user         = user_lookup(REDIS, study, netid, project_role, consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          unless role.save
            if role.errors.on(:study_id)=="can't be blank"
              REDIS.sadd('phantom_studies',study)
              study_keys = REDIS.keys "*#{study}*"
              study_keys.each{|k| REDIS.del k}
            elsif role.errors.on(:study_id) =='has already been taken'
              puts "Study User validation error - Co Investigator : #{study} - #{netid} - #{project_role} - #{consent_role} "
              begin
                first_role = role.study.roles.detect{|r| r.user = role.user}
                puts "Already listed as #{first_role.project_role} - #{first_role.consent_role}"
              rescue Exception => e
                puts "Exception Caught"
              end
            end
          end
        rescue Exception    => e
          puts "failed to create CoInvestigator for study #{study} and user #{netid}"
        end
      end
    end
    
    puts "Authorized Personnel"
    authorized_personnel_list = REDIS.keys 'role:authorized_personnel:*'
    authorized_personnel_list.each do |authorized_person|
      if (REDIS.type authorized_person) != 'set'
        study, netid = authorized_person.split(':')[2,3]
        project_role = REDIS.hget(authorized_person,'project_role')
        consent_role = REDIS.hget(authorized_person,'consent_role')
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.user         = user_lookup(REDIS, study, netid, project_role, consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          unless role.save
            if role.errors.on(:study_id)=="can't be blank"
              REDIS.sadd('phantom_studies',study)
              study_keys = REDIS.keys "*#{study}*"
              study_keys.each{|k| REDIS.del k}
            elsif role.errors.on(:study_id) == 'has already been taken'
              puts "Study User validation error - Authorized Personnel : #{study} - #{netid} - #{project_role} - #{consent_role} "
              begin
                first_role = role.study.roles.detect{|r| r.user = role.user}
                puts "Already listed as #{first_role.project_role} - #{first_role.consent_role}"
              rescue Exception => e
                puts "Exception Caught"
              end
            end
            
          end
        rescue Exception    => e
          puts "Failed to create Role
          Exception Message: #{e.message}
          Study: #{study} 
          User: #{netid}
          Project Role: #{project_role}
          Consent Role: #{consent_role}"
        end
      end
    end
  end

  private
  def self.user_lookup(redis, study, netid, project_role, consent_role)
    if (user= User.find_by_netid(netid))
      user
    elsif(user2=User.find_by_netid(netid.downcase))
      user2
    elsif(user3 = User.find_by_netid(redis.hget("role:user_aliases", netid)))
      user3
    elsif(user4 = User.find_by_netid(redis.hget("role:user_aliases", netid.downcase)))
      user4
    else
      puts "Missing Netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
      Resque.enqueue(IncompleteRoleProcessor, study, netid, project_role, consent_role)
      nil
    end
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
