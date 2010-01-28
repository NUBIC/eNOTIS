
require 'couchrest'

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

  attr_accessor :pi #temp until full transition can be made
  attr_accessor :coords #temp until full transition can be made
  attr_accessor :irb_statur #temp ... as above

  def self.couch_connect
    return @couch if @couch
    config = WebserviceConfig.new("/etc/nubic/couch-#{RAILS_ENV.downcase}.yml")
    @couch = CouchRest.database("#{config[:url]}:#{config[:port]}/#{config[:db]}")
  end

  def self.couch_doc(study_id)
    begin
      couch_connect.get(study_id)
    rescue
      # TODO remove this when this access is depricated
      {:irb_number => "not found", :pi => [{}], :coords => [{}]} # fail semi-silently, the doc was not found for some reason
    end
  end

  # After load hook to load up the dynamic methods/attrs from our
  # CouchDB store
  def after_initialize
    doc_str = Study.couch_doc(self.irb_number) 
    @eirb_json = doc_str
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
       def #{k} 
         @eirb_json[:#{k}] || @eirb_json["#{k}"]
       end
      })
    end
  end

  #methods to depricate
  def pi_netid
    pi.first["netid"] || "missing"
  end

  def pi_first_name
    pi.first["first_name"] || "missing"
  end

  def pi_last_name
    pi.first["last_name"] || "missing"
  end

  def pi_email
    pi.first["email"] || "missing"
  end

  def sc_netid
    coords.first["netid"] || "missing"
  end

  def sc_first_name
    coords.first["first_name"] || "missing"
  end

  def sc_last_name
    coords.first["last_name"] || "missing"
  end

  def sc_email
    coords.first["email"] || "missing"
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
    user.admin? or coordinators.map(&:user).include? user
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



