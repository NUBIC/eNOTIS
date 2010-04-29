class Role < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  validates_presence_of :user_id
  validates_presence_of :study_id
  
  attr_protected :consent_role #defines app permissions

  def can_accrue?
    consent_role == "Obtaining"
  end
  
  def self.update_from_redis
    Role.delete_all
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis  = Redis::Namespace.new('eNOTIS:role',:redis => Redis.new(config))
    study_roles_list = redis.keys '*'
    study_roles_list.each do |study_role|
      study,netid = study_role.split(':')
      begin
        role = Role.new
        role.study = Study.find_by_irb_number(study)
        role.user = User.find_by_netid(netid)
        role.project_role = redis.hget(study_role,'project_role')
        role.consent_role = redis.hget(study_role,'consent_role')
        role.save
      rescue Exception => e
        puts "failed to create Authorized Person for study #{study} and user #{netid}"
      end
    end
  end
end
