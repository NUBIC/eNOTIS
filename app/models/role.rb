class Role < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  validates_presence_of :user_id
  validates_presence_of :study_id
  
  attr_protected :consent_role #defines app permissions
  # validates_uniqueness_of :user_id, :scope => [:study_id, :project_role, :consent_role]
  def can_accrue?
    consent_role == "Obtaining"
  end
  
  def self.update_from_redis
    #ActiveRecord::Base.connection.execute('truncate roles restart identity')
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis  = Redis::Namespace.new('eNOTIS',:redis => Redis.new(config))
    
    puts "Principal Investigators"
    project_role = "Principal Investigator"
    consent_role = "Obtaining"
    principal_investigator_list = redis.keys 'role:principal_investigators:*'
    principal_investigator_list.each do |principal_investigator|
      study = principal_investigator.split(":")[2]
      netids = redis.smembers(principal_investigator)
      netids.each do |netid|
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.user         = user_lookup(redis,study,netid,project_role,consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          role.save
        rescue Exception    => e
          puts "failed to create Authorized Person for study #{study} and user #{netid}"
        end
      end
    end
    
    puts "Co Investigators"
    project_role = "Co-Investigator"
    consent_role = "Obtaining"
    co_investigator_list        = redis.keys 'role:co_investigators:*'
    co_investigator_list.each do |co_investigator|
      study = co_investigator.split(":")[2]
      netids = redis.smembers(co_investigator)
      netids.each do |netid|
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.user         = user_lookup(redis,study,netid,project_role,consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          role.save
        rescue Exception    => e
          puts "failed to create CoInvestigator for study #{study} and user #{netid}"
        end
      end
    end
    
    puts "Authorized Personnel"
    authorized_personnel_list   = redis.keys 'role:authorized_personnel:*'
    authorized_personnel_list.each do |authorized_person|
      if (redis.type authorized_person) != 'set'
        study,netid = authorized_person.split(':')[2,3]
        project_role = redis.hget(authorized_person,'project_role')
        consent_role = redis.hget(authorized_person,'consent_role')
        begin
          role              = Role.new
          role.study        = Study.find_by_irb_number(study)
          role.user         = user_lookup(redis,study,netid,project_role,consent_role)
          role.project_role = project_role
          role.consent_role = consent_role
          role.save
        rescue Exception    => e
          puts "\tfailed to create Role - for study #{study} and user #{netid}
          on project_role #{project_role} -  #{consent_role}"
        end
      end
    end
  end

  private
  def self.user_lookup(redis,study,netid,project_role,consent_role)
    if (user= User.find_by_netid(netid))
      user
    elsif(user2=User.find_by_netid(netid.downcase))
      user2
    elsif(user3 = User.find_by_netid(redis.hget("user_aliases",netid)))
      user3
    elsif(user4 = User.find_by_netid(redis.hget("user_aliases",netid.downcase)))
      user4
    else
      puts "\tMissing Netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
      Resque.enqueue(ENRedisIncompleteRole, study, netid, project_role, consent_role)
      nil
    end
  end
end
