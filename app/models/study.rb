require 'chronic'

# Represents a Clinical Study/Trial.
class Study < ActiveRecord::Base

  # Associations
  has_many :involvements
  has_many :roles
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
        :accrual_goal                      => study[:accrual_goal], 
        :approved_date                     => Chronic.parse(study[:approved_date]),
        :clinical_trial_submitter          => study[:clinical_trial_submitter], 
        :closed_or_completed_date          => Chronic.parse(study[:closed_or_completed_date]),
        :created_date                      => Chronic.parse(study[:created_date]),
        :description                       => study[:description],
        :exclusion_criteria                => study[:exclusion_criteria],
        :expiration_date                   => Chronic.parse(study[:expiration_date]),
        :expired_date                      => Chronic.parse(study[:expired_date]), 
        :fda_offlabel_agent                => study[:fda_offlabel_agent],
        :fda_unapproved_agent              => study[:fda_unapproved_agent],
        :inclusion_criteria                => study[:inclusion_criteria],
        :irb_number                        => study[:irb_number],
        :irb_status                        => study[:irb_status],
        :is_a_clinical_investigation       => study[:is_a_clinical_investigation],
        :modified_date                     => Chronic.parse(study[:modified_date]),
        :multi_inst_study                  => study[:multi_inst_study],
        :name                              => study[:name],
        :periodic_review_open              => study[:periodic_review_open],
        :research_type                     => study[:research_type],
        :review_type_requested             => study[:review_type_requested],
        :subject_expected_completion_count => study[:subject_expected_completion_count],
        :title                             => study[:title],
        :total_subjects_at_all_ctrs        => study[:total_subjects_at_all_ctrs]
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