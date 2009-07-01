require 'webservices/plugins/eirb_services'

class Coordinator < ActiveRecord::Base
  belongs_to :user
  belongs_to :study
  delegate :first_name, :last_name, :netid, :to => :user
  has_paper_trail

  def self.import_from_eirb
    # get the access list (the coordinator list)
    logger.info "Starting the import"
    access = EirbServices.find_study_access
    access.each do |role|
      logger.info "Processing role #{role.inspect}"
      if study = Study.find(:first, :conditions => "irb_number ='#{role[:irb_number]}'",:span => :global)
        logger.info "Found study #{role[:irb_number]}"        
        study.save
        unless role[:netid].empty?
         unless user = User.find_by_netid(role[:netid])
           user_hash = EirbServices.find_by_netid({:netid => role[:netid]}).first
           logger.info user_hash.inspect
           user = User.create(user_hash)
         end
         if user
           study.coordinators.create(:user_id => user.id)
           logger.info "Created coordinator #{user.netid}"
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
