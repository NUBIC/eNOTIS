# Represents a subject that has (possibly) been part of a clinical research study.
# We store enough data to sync the local db record with the subject data in the EDW.
# The model stores the fields and information about the source system for the data.
require 'ruport'
require 'two_digit_year'

class Subject < ActiveRecord::Base
  
  # Associations
  has_many :involvements
  has_many :studies, :through => :involvements
  has_many :involvement_events, :through => :involvements

  # Named scopes
  named_scope :on_studies, lambda {|study_ids| { :include => :involvements, :conditions => ['involvements.study_id in (?)', study_ids], :order => 'subjects.last_name, subjects.first_name ASC' } }

  # Mixins
  acts_as_reportable
  has_paper_trail
  
  # Public class methods
  def self.find_or_create(params)
    s = params[:subject]
    s.keys.each{|k| s[k] = nil if s[k].blank?}
    s.delete(:case_number)
    Subject.find(:first, :conditions => s) || Subject.create(s)
  end
  
  # Public instance methods
  def mrn=(mrn)
    write_attribute :mrn, (mrn.blank? ? nil : mrn) # ignore blank mrns from add subject form
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
  
  # There is a subject_name_helper method that includes styles for the name...
  # The helper method is generally better to use when writing out to the HTML UI
  def name
    if first_name.blank? and last_name.blank?
      "(no name)"
    else
      "#{self.last_name}, #{self.first_name}"
    end
  end
  
  def birth_date=(date)
    write_attribute :birth_date, TwoDigitYear.compensate_for_two_digit_year(date)
  end

  def merge!(subject)
   #This method is used to merge an existing subject and involvements
   #to a this subject
   self.save
   self.involvements << subject.involvements
   #subject.delete 
  end
  
  def other_studies(study)
    study.blank? ? studies : studies - [study]
  end
  
end
