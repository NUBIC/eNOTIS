class AuthorizedPerson < ActiveRecord::Base
  belongs_to :user
  belongs_to :study
  
  def self.update_from_redis
    AuthorizedPerson.delete_all
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis  = Redis::Namespace.new('eNOTIS:authorized_personnel',:redis => Redis.new(config))
    authorized_people_per_study_list = redis.keys '*'
    authorized_people_per_study_list.each do |study_person|
      study,netid = study_person.split(':')
      begin
        ap = AuthorizedPerson.new
        ap.study = Study.find_by_irb_number(study)
        ap.user = User.find_by_netid(netid)
        ap.project_role = redis.hget(study_person,'project_role')
        ap.consent_role = redis.hget(study_person,'consent_role')
        ap.save
      rescue Exception => e
        puts "failed to create Authorized Person for study #{study} and user #{netid}"
      end
    end
  end
end
