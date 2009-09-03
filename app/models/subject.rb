require 'webservices/webservices'

# Represents a subject that has (possibly) been part of a clinical research study.
# We store enough data to sync the local db record with the subject data in the EDW.
# The model stores the fields and information about the source system for the data.

class Subject < ActiveRecord::Base
  include WebServices

  # Associations
  has_many :involvements
  has_many :studies, :through => :involvements
  has_many :involvement_events, :through => :involvements

  # Named scopes
  named_scope :on_studies, lambda {|study_ids| { :include => :involvements, :conditions => ['involvements.study_id in (?)', study_ids], :order => 'subjects.last_name, subjects.first_name ASC' } }

  # Mixins
  has_paper_trail
  
  # Public instance methods
  def mrn=(mrn)
    # add subject form passes blank string mrn's when we send on 
    write_attribute :mrn, (mrn.blank? ? nil : mrn)
  end
  
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

  def merge!(subject)
   #This method is used to merge an existing subject and involvements
   #to a this subject
   self.save
   self.involvements << subject.involvements
   #subject.delete 
  end
  
  # Public class methods
  
  def self.find_or_create(params,study=nil,user="EDWeNOTIS")
    # try to find by mrn first
    if !params[:mrn].blank?
      subject = Subject.find(:first, :conditions =>{:mrn=>params[:mrn]},:span=>:global,:service_opts=>{:netid=>user})
      if !subject.nil?
        subject.save
        return subject
      end 
    end
      # if we've made it this far, the mrn was blank or the subject wasn't found by mrn
    if !params[:first_name].blank? or !params[:last_name].blank? or !params[:birth_date].blank?
      #Check if there is a subject with same identifiers on the given study
      Subject.find_all_by_first_name_and_last_name_and_birth_date(params[:first_name],params[:last_name],params[:birth_date]).each do |subject|
        return subject if subject.studies.include?study
      end
       #if we've reached here it means that there's no subject with these credentials on the study
      Subject.create(params)
    else
      return nil
    end
  end
    
end
