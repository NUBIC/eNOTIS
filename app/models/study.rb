require 'chronic'

# Represents a Clinical Study/Trial.
class Study < ActiveRecord::Base

  # Associations
  has_many :involvements
  has_many :coordinators
  has_many :co_investigators
  has_one  :principal_investigator
  has_many :subjects, :through => :involvements
  has_many :study_uploads

  # Validators
  validates_format_of :irb_number, :with => /^STU.+/, :message => "invalid study number format"
  
  def self.cache_connect
    return @cache if @cache
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    @cache = Redis::Namespace.new('eNOTIS:study', :redis => Redis.new(config))
  end
  
  def self.redis_cache_lookup(irb_number)
    HashWithIndifferentAccess.new(cache_connect.hgetall(irb_number))
  end  
  
  def self.update_from_redis
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root + 'config/redis.yml'))[Rails.env]
    redis = Redis::Namespace.new('eNOTIS:study',:redis => Redis.new(config))
    study_list = redis.keys '*'
    study_list.each do |redis_study|
      study  = HashWithIndifferentAccess.new(redis.hgetall(redis_study))
      params = {
        :irb_number               => study[:irb_number],
        :name                     => study[:name],
        :title                    => study[:title],
        :expiration_date          => Chronic.parse(study[:expiration_date]),
        :irb_status               => study[:irb_status],
        :approved_date            => Chronic.parse(study[:approved_date]),
        :research_type            => study[:research_type],
        :closed_or_completed_date => study[:closed_or_completed_date]
      }
      local_study = find_by_irb_number(params[:irb_number])
      if local_study.nil?
        create(params)
      else
        local_study.update_attributes!(params)
      end
    end
  end

  # methods to deprecate
  ######################
  # pi_last_name is being used, others (sc_email, etc.) have been moved to application_helper.rb's people_info method - yoon
  def pi_last_name
    logger.warn("DEPRECATED METHOD")
    self.principal_investigator.last_name
  end

  def phase
    nil
  end

  def status
    irb_status
  end

  def accrual_goal
    cache_accrual_goal rescue ""
  end
  ##########################
  # end methods to deprecate


  # irb_number instead of id in urls
  def to_param
    self.irb_number
  end

  def has_coordinator?(user)
    user.admin? or coordinators.map(&:netid).include? user.netid
  end

  def accrual
    involvements.count
  end

  def may_accrue?
    can_accrue?
  end

  def can_accrue?
    # For possible eIRB statuses, see doc/terms.csv
    ["Approved", "Exempt Approved", "Not Under IRB Purview",
      "Revision Closed", "Revision Open"].include? self.status
  end
end