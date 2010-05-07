class Role < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  validates_presence_of :user_id
  validates_presence_of :study_id
  
  attr_protected :consent_role #defines app permissions

  def can_accrue?
    consent_role == " "
  end
  
  def self.update_from_redis
    Role.delete_all
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis  = Redis::Namespace.new('eNOTIS:role',:redis => Redis.new(config))
    
    puts "Principal Investigators"
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
            role.project_role = "Principal Investigator"
            role.consent_role = "Obtaining"
            role.save
          rescue Exception    => e
            puts "failed to create Authorized Person for study #{study} and user #{netid}"
          end
        end
      end
    end
    
    puts "Co Investigators"
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
            role.project_role = "Co Investigator"
            role.consent_role = "Obtaining"
            role.save
          rescue Exception    => e
            puts "failed to create Authorized Person for study #{study} and user #{netid}"
          end
        end
      end
    end
    
    puts "Unstructured Text Entry"
    authorized_personnel_list   = redis.keys 'authorized_personnel:*'
    authorized_personnel_list.each do |authorized_person|
      study,netid = authorized_person.split(':')[1,2]
      begin
        role              = Role.new
        role.study        = Study.find_by_irb_number(study)
        role.user         = User.find_by_netid(netid)
        role.project_role = redis.hget(authorized_person,'project_role')
        role.consent_role = redis.hget(authorized_person,'consent_role')
        role.save
      rescue Exception    => e
        puts "failed to create Authorized Person for study #{study} and user #{netid}"
      end      
    end
  end
end
