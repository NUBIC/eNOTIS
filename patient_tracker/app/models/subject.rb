# Represents a subject that has (at some point) been on a clinical trial study
# We store enough data to reconcile the local db store record with the subject data in 
# the EDW. The model stores the reconciliation fields and information about the source system
# for the data.
require 'lib/webservices/webservices'
class Subject < ActiveRecord::Base #.extend WebServices
  include WebServices
  has_many :involvements
  has_many :subject_events 
  has_many :studies, :through => :involvements

  $plugins = [EdwServices]
  
  def synced?
    !self.synced_at.nil?
  end
  def stale?
    synced? ? self.synced_at < 12.hours.ago : true 
  end
  def sync!(attrs)
    self.attributes = attrs
    # self.chagnes from http://ryandaigle.com/articles/2008/3/31/what-s-new-in-edge-rails-dirty-objects
    self.pre_sync_data = self.changes.map{|key, array_value| "#{key} changed from #{array_value[0].to_s} to #{array_value[1].to_s}"}.join(",0") unless synced?
    self.save
  end
end
