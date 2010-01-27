
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

  def self.couch_connect
    return @couch if @couch
    config = WebserviceConfig.new("/etc/nubic/couch-#{RAILS_ENV.downcase}.yml")
    @couch = CouchRest.database("#{config[:url]}:#{config[:port]}/#{config[:db]}")
  end

  def self.couch_doc(study_id)
    couch_connect.get(study_id)
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

  # irb_number instead of id in urls
  def to_param
    self.irb_number
  end
  
  def has_coordinator?(user)
    user.admin? or coordinators.map(&:user).include? user
  end

  def may_accrue?
    can_accrue?
  end

  def can_accrue?
    # For possible eIRB statuses, see doc/terms.csv
    ["Approved", "Exempt Approved", "Not Under IRB Purview", "Revision Closed", "Revision Open"].include? self.status
  end
  

end



