
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
  
  # Validators
  validates_format_of :irb_number, :with => /^STU.+/, :message => "invalid study number format"

  attr_accessor :eirb_json

#  [:principal_investigators, :coordinators, :co_investigators] each do |m|
#    attr_accessor m
#  end

  def self.cache_connect
    return @cache if @cache
    config = WebserviceConfig.new("/etc/nubic/couch-#{RAILS_ENV.downcase}.yml")
    @cache = CouchRest.database("#{config[:url]}:#{config[:port]}/#{config[:db]}")
  end

  def self.cache_doc(study_id)
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

  def self.update_from_cache
    study_list = couch_view(:all_status)
    study_list["rows"].each do |study|
      local_study = find_by_irb_number(study["id"])
      params = {:irb_number => study["id"],
              :name => study["name"],
              :title => study["title"],
              :description => study["description"],
              :expiration_date => Chronic.parse(study["expiration_date"]),
              :irb_status => study["irb_status"],
              :approved_date => Chronic.parse(study["approved_date"]),
              :research_type => study["research_type"],
              :closed_or_completed_date => study["closed_or_completed_date"]} #TODO THIS will break next cache update - notice name change for attr :-BLC

      if local_study.nil?
        create(params)   
      else
        local_study.update_attributes(params)
      end
    end
  end

  # After load hook to load up the dynamic methods/attrs from our
  # CouchDB store
  def after_initialize
    refresh_cache
  end

  def refresh_cache
    @eirb_json = Study.cache_doc(self.irb_number) 
    attach_attributes
  end

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

  #methods to depricate
  def pi_netid
    cache_principal_investigators.first["netid"] || "missing"
  end

  def pi_first_name
    cache_principal_investigators.first["first_name"] || "missing"
  end

  def pi_last_name
    cache_principal_investigators.first["last_name"] || "missing"
  end

  def pi_email
    cache_principal_investigators.first["email"] || "missing"
  end

  def sc_netid
    cache_coordinators.first["netid"] || "missing"
  end

  def sc_first_name
    cache_coordinators.first["first_name"] || "missing"
  end

  def sc_last_name
    cache_coordinators.first["last_name"] || "missing"
  end

  def sc_email
    cache_coordinators.first["email"] || "missing"
  end

  def phase
    nil
  end
  # end of methods to depricate



  # irb_number instead of id in urls
  def to_param
    self.irb_number
  end

  def status
    irb_status
  end
  
  def has_coordinator?(user)
    user.admin? or coordinators.map{|m| m[:netid]}.include? user
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



