
require 'couchrest'
require 'lib/webservices'
require 'chronic'

# Represents a Clinical Study/Trial.
class Study < ActiveRecord::Base

  
  # Associations
  has_many :involvements
  has_many :coordinators
  has_many :subjects, :through => :involvements
  has_many :study_uploads 

  attr_accessor :eirb_json

  # Validators
  validates_format_of :irb_number, :with => /^STU.+/, :message => "invalid study number format"

  def self.cache_connect
    return @cache if @cache
    config = WebserviceConfig.new("/etc/nubic/couch-#{RAILS_ENV.downcase}.yml")
    @cache = CouchRest.database("#{config[:url]}:#{config[:port]}/#{config[:db]}")
  end

  def self.cache_doc(study_id = nil)
    begin
      cache_connect.get(study_id)
    rescue
      # TODO remove this when old method name access is depricated
      {:irb_number => "Not Found", :principal_investigators => [{}], :coordinators=> [{}], :co_investigators => [{}]} # fail semi-silently, the doc was not found for some reason
    end
  end

  def self.cache_view(view)
    cache_connect.view("study/#{view}")
  end

  def self.update_all_from_cache
    study_list = cache_view(:all)
    study_list["rows"].each do |study_hash|
      study = study_hash["value"]
      params = {:irb_number => study["irb_number"],
              :name => study["name"],
              :title => study["title"],
              :expiration_date => Chronic.parse(study["expiration_date"]),
              :irb_status => study["irb_status"],
              :approved_date => Chronic.parse(study["approved_date"]),
              :research_type => study["research_type"],
              :closed_or_completed_date => study["closed_or_completed_date"]}
      local_study = find_by_irb_number(params[:irb_number])      
      if local_study.nil?
        create(params)   
      else
        local_study.update_attributes!(params)
      end
    end
  end

  # TODO: consider refactoring the data cache to a separate class
  def self.update_coordinators_from_cache
    #clearing the old data
    Coordinator.delete_all
    #looks at the local studies and updates access list from the cache
    coord_list = cache_view(:access_list)
    coord_list["rows"].each do |entry|
      study = find_by_irb_number(entry["key"])
      if study 
        
        entry["value"].each do |user_hash|        
          params = {:netid => user_hash["netid"],
            :email => user_hash["email"],
            :first_name => user_hash["first_name"],
            :last_name => user_hash["last_name"]}
          unless params[:netid].nil? || params[:netid].empty? # a lot are blank actually
            user = User.find_by_netid(params[:netid])
            if user
              user.update_attributes(params)
            else
              user = User.create(params)
            end
            study.coordinators.create(:user => user)
          end
          
        end
      end
    end    
  end

  # After load hook to load up the dynamic methods/attrs from our
  # CouchDB store
  def after_initialize
    refresh_cache
  end

  def refresh_cache
    self.eirb_json = Study.cache_doc(self.irb_number) 
  end

  def eirb_json=(val)
    @eirb_json = val
    attach_attributes
  end

  def eirb_json
    @eirb_json
  end

  # methods to depricate
  ######################
    # pi_last_name is being used, others (sc_email, etc.) have been moved to application_helper.rb's people_info method - yoon
    def pi_last_name
      cache_principal_investigators.first["last_name"] || "missing"
    end

    def phase
      nil
    end

    def status
      irb_status
    end
  ##########################
  # end methods to depricate


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

  private
  # attaching the hash keys as methods to have them
  # return data as if they were defined attributes of 
  # the model. Note: they are read-only
  def attach_attributes
    attach = @eirb_json.clone
    attach.delete(:irb_number)
    attach.each do |k,v|
      instance_eval(%{ 
       def cache_#{k} 
         @eirb_json[:#{k}] || @eirb_json["#{k}"]
       end
      })
    end
  end

end



