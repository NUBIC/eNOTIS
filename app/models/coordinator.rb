class Coordinator < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user

  # Mixins
  # has_paper_trail <-- commented out because the data that populates this model is from eIRB. We don't need to track the versions -BLC 02/16/10
 
  # Validators
  validates_uniqueness_of :user_id, :scope => :study_id
  validates_presence_of :user_id, :study_id

  def self.update_from_redis
    Coordinator.delete_all
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis  = Redis::Namespace.new('eNOTIS:coordinators',:redis => Redis.new(config))
    coordinator_study_user_list = redis.keys '*'
    coordinator_study_user_list.each do |study|
      redis.smembers(study).each do |user|
        begin
          coordinator       = Coordinator.new
          coordinator.study = Study.find_by_irb_number(study)
          coordinator.user  = User.find_by_netid(user)
          coordinator.save
        rescue Exception => e
          puts "failed to create coordinator for study #{study} and user #{user}"
        end
      end
    end
  end
end
