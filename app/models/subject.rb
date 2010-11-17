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
  named_scope :on_notis_studies, :conditions => {:data_source => "NOTIS"}, :joins => :involvements
  # Mixins
  acts_as_reportable
  has_paper_trail
  
  # Public instance methods
  def nmff_mrn=(mrn)
    write_attribute :nmff_mrn, (mrn.blank? ? nil : mrn) # ignore blank mrns from add subject form
  end
  
  def nmh_mrn=(mrn)
    write_attribute :nmh_mrn, (mrn.blank? ? nil : mrn) # ignore blank mrns from add subject form
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
