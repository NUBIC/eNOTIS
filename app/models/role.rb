class Role < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  validates_presence_of :user_id
  validates_presence_of :study_id
  
  attr_protected :consent_role #defines app permissions
  validates_uniqueness_of :user_id, :scope => [:study_id, :project_role, :consent_role]
  def can_accrue?
    consent_role == "Obtaining"
  end
  
  def self.update_from_redis
    ActiveRecord::Base.connection.execute('truncate roles restart identity')
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis  = Redis::Namespace.new('eNOTIS:role',:redis => Redis.new(config))
    
    puts "Principal Investigators"
    project_role = "Principal Investigator"
    consent_role = "Obtaining"
    principal_investigator_list = redis.keys 'principal_investigators:*'
    principal_investigator_list.each do |principal_investigator|
      study = principal_investigator.split(":")[1]
      
      principal_investigator.each do |pis|
        netids = redis.smembers(principal_investigator)
        netids.each do |netid|
          begin
            role              = Role.new
            role.study        = Study.find_by_irb_number(study)
            role.user         = User.find_by_netid(netid)
            role.project_role = project_role
            role.consent_role = consent_role
            unless role.save
              if role.errors.on(:user_id) == "can't be blank"
                puts "\tMissing netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
                Resque.enqueue(ENRedisIncompleteRole, study, netid, project_role, consent_role)
              elsif role.errors.on(:study_id) == "can't be blank"
                Resque.enqueue(ENRedisMissingStudy, study)
              else
                debugger
                puts "Error Saving Principal Invesigator - #{study} - #{netid} - #{project_role} - #{consent_role}"
              end
            end
          rescue Exception    => e
            puts "failed to create Authorized Person for study #{study} and user #{netid}"
          end
        end
      end
    end
    
    puts "\tCo Investigators"
    project_role = "Co-Investigator"
    consent_role = "Obtaining"
    
    co_investigator_list        = redis.keys 'co_investigators:*'
    co_investigator_list.each do |co_investigator|
      study = co_investigator.split(":")[1]
      co_investigator.each do |coi|
        netids = redis.smembers(co_investigator)
        netids.each do |netid|
          begin
            role              = Role.new
            role.study        = Study.find_by_irb_number(study)
            role.user         = User.find_by_netid(netid)
            role.project_role = project_role
            role.consent_role = consent_role
            unless role.save
              if role.errors.on(:user_id) == "can't be blank"
                puts "\tMissing Netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
                Resque.enqueue(ENRedisIncompleteRole, study, netid, project_role, consent_role)
              elsif role.errors.on(:study_id) == "can't be blank"
                Resque.enqueue(ENRedisMissingStudy, study)
              else
                debugger
                puts "Error Saving Co-Invesigator - #{study} - #{netid} - #{project_role} - #{consent_role}"
              end
            end
          rescue Exception    => e
            puts "failed to create CoInvestigator for study #{study} and user #{netid}"
          end
        end
      end
    end
    
    puts "\tUnstructured Text Entry"
    authorized_personnel_list   = redis.keys 'authorized_personnel:*'
    authorized_personnel_list.each do |authorized_person|
      study,netid = authorized_person.split(':')[1,2]
      project_role = redis.hget(authorized_person,'project_role')
      consent_role = redis.hget(authorized_person,'consent_role')
      begin
        role              = Role.new
        role.study        = Study.find_by_irb_number(study)
        role.user         = User.find_by_netid(netid)
        role.project_role = project_role
        role.consent_role = consent_role
        unless role.save
          if role.errors.on(:user_id) == "can't be blank"
            puts "\tMissing netid = #{study} - #{netid} - #{project_role} - #{consent_role}"
            Resque.enqueue(ENRedisIncompleteRole, study, netid, project_role, consent_role)
          elsif role.errors.on(:study_id) == "can't be blank"
            Resque.enqueue(ENRedisMissingStudy, study)
          elsif role.errors.on(:user_id) == "has already been taken"
            Resque.enqueue(ENRedisDupeUser, study, netid, project_role, consent_role)
          else
            debugger
            puts "UnstructuredRoleError - #{study} - #{netid} - #{project_role} - #{consent_role}"
          end
        end
      rescue Exception    => e
        puts "\tfailed to create Role - for study #{study} and user #{netid}
        on project_role #{project_role} -  #{consent_role}"
      end      
    end
  end
end
