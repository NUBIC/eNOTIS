require 'lib/webservices/webservices'

# Represents a subject that has (possibly) been part of a clinical research study.
# We store enough data to sync the local db record with the subject data in the EDW.
# The model stores the fields and information about the source system for the data.

class Subject < ActiveRecord::Base
  include WebServices

  # Associations
  has_many :involvements
  has_many :studies, :through => :involvements
  has_many :involvement_events, :through => :involvements

  # Mixins
  has_paper_trail
  $plugins = [EdwServices]
  
  # Public instance methods
  def synced?
    !self.synced_at.nil?
  end

  def stale?
    synced? ? self.synced_at < 12.hours.ago : true 
  end

  def sync!(attrs)
    self.attributes = attrs
    # self.changes via http://ryandaigle.com/articles/2008/3/31/what-s-new-in-edge-rails-dirty-objects
    self.pre_sync_data = self.changes.map{|key, array_value| "#{key} changed from #{array_value[0].to_s} to #{array_value[1].to_s}"}.join(",0") unless synced?
    self.save
    return self
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def birth_date=(date)
    write_attribute :birth_date, Chronic.parse(date)
  end
  
  # Public class methods
  
  def self.find_or_create(params)
    if !params[:mrn].blank?
      Subject.find(:first, :conditions => ["mrn=?", params[:mrn]], :span=>:global)
    elsif !params[:first_name].blank? or !params[:last_name].blank? or !params[:birth_date].blank?
      Subject.create(params)
    else
      return nil
    end
  end
end
