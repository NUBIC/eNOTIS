class CoInvestigator < ActiveRecord::Base
  
  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  # Mixins
  # has_paper_trail <-- commented out because the data that populates this model is from eIRB. We don't need to track the versions -BLC 02/16/10
 
  # Validators
  validates_uniqueness_of :user_id, :scope => :study_id

  def self.update_from_redis
    CoInvestigator.delete_all
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis  = Redis::Namespace.new('eNOTIS:co_investigators',:redis => Redis.new(config))
    co_investigator_study_user_list = redis.keys '*'
    co_investigator_study_user_list.each do |study|
      redis.smembers(study).each do |user|
        begin
          co_investigator       = CoInvestigator.new
          co_investigator.study = Study.find_by_irb_number(study)
          co_investigator.user  = User.find_by_netid(user)
          co_investigator.save
        rescue Exception => e
          puts "failed to create co_investigator for study #{study} and user #{user}"
        end
      end
    end
  end
  
end
