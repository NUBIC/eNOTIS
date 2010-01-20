require 'webservices/plugins/eirb_services'

class Coordinator < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :name, :netid, :to => :user
  
  # Mixins
  has_paper_trail
 
  # Validators
  validates_uniqueness_of :user_id, :scope => :study_id
  
  # Public class methods
  # TODO Refactor this into several smaller methods -blc
  def self.import_from_eirb
    # get the access list (the coordinator list)
    logger.info "Starting the import"
    access = EirbServices.find_study_combined_access
    access.each do |role|
      logger.info "Processing role #{role.inspect}"
      study_hash = EirbServices.find_basics(:irb_number => role[:irb_number])
      if study_hash
        s = study_hash.first
        study = Study.new
        study.irb_number = s[:irb_number]
        study.name = s[:name]
        study.title = s[:title]
        study.description = s[:desription]
        study.accrual_goal = s[:accrual_goal]
        study.research_type = s[:research_type]
        study.multi_inst_study = s[:multi_inst_study]
        study.irb_status = s[:irb_status]
        study.approved_date = s[:approved_date]
        study.expiration_date = s[:expiration_date]
        study.pi_netid = s[:pi_netid]
        study.pi_first_name = s[:pi_first_name]
        study.pi_last_name = s[:pi_last_name]
        study.pi_email = s[:pi_email]
        study.sc_netid = s[:sc_netid]
        study.sc_first_name = s[:sc_first_name]
        study.sc_last_name = s[:sc_last_name]
        study.sc_email = s[:sc_email]
        study.periodic_review_open = s[:periodic_review_open]
        study.save
        logger.info "Found and created study #{role[:irb_number]}"        
        study.save
        unless role[:netid].nil? or role[:netid].empty?
          #fixing the case
          role[:netid].downcase!
          user = User.find_by_netid(role[:netid])
         if user.nil?
           user_hash = EirbServices.find_user({:netid => role[:netid]}).first
           logger.info user_hash.inspect
           user = User.create(user_hash)
         end
         if user
           unless study.coordinators.find(:first,:conditions => ["user_id = ?",user]) 
             study.coordinators.create(:user_id => user.id)
             logger.info "Created coordinator #{user.netid}"
           end
         else
           logger.warn "Problem finding or creating user #{role[:netid]}"
         end
        else
          logger.warn "NetID blank for #{role.inspect}"
        end
      else
        logger.warn "Did NOT find study #{role[:irb_number]}"
      end
    end
  end

end
