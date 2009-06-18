# Represents a subject that has (at some point) been on a clinical trial protocol
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
  
  # Also aliased in spec/factories.rb
  alias_attribute :last_synced, :last_reconciled
  alias_attribute :sync_status, :reconcile_status
  
  def synced?
    !self.last_synced.nil?
  end

  def reconcile(values)
    values[:last_reconciled]=Time.now
    Subject.update(self.id,values)  
  end

  def current?
   self.last_reconciled > 12.hours.ago unless last_reconciled.nil?
  end

  def confirmed!
    self.reconciled = true
    self.save
  end

  def confirmed?
    self.reconciled
  end 

end
