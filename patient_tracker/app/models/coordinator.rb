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
  
  # TODO Refactor this into several smaller methods -blc
  def self.import_from_eirb
    # get the access list (the coordinator list)
    logger.info "Starting the import"
    access = EirbServices.find_study_access
    access.each do |role|
      logger.info "Processing role #{role.inspect}"
      if study = Study.find(:first, :conditions => "irb_number ='#{role[:irb_number]}'",:span => :global)
        logger.info "Found study #{role[:irb_number]}"        
        study.save
        unless role[:netid].nil? or role[:netid].empty?
          #fixing the case
          role[:netid].downcase!
          user = User.find_by_netid(role[:netid])
         if user.nil?
           user_hash = EirbServices.find_by_netid({:netid => role[:netid]}).first
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
