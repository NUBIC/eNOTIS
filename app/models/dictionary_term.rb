# 'Dictionary', according to the dictionary, is	a list of codes, terms, keys, 
# etc., and their meanings, used by a computer program or system.
#
# This class is used a reference for the clinical terminology of the system, 
# we call it "DictionaryTerm" (with a dictionary_terms database table) to 
# follow convention but it is essentially a dictionary.

class DictionaryTerm < ActiveRecord::Base

  # Validators
  validates_presence_of :term, :code
  validates_uniqueness_of :term, :scope => :category 
  validates_uniqueness_of :code, :scope => :category

  # Filters
  before_save :downcase_attributes
  
  # Public class methods
  # TODO refactor this into separate classes with foreign key constraints - yoon
  class << self 
    def all_terms
      @@all ||= self.all
    end
    %w(gender ethnicity race event).each do |category|
      # gender_objects, ethnicity_objects, race_objects, event_objects
      define_method("#{category}_objects".to_sym){ self.all_terms.select{|x| x.category == category} }
      # genders, ethnicities, races, events (just the terms)
      define_method(category.pluralize.to_sym){ self.all_terms.select{|x| x.category == category}.map{|x| x.term} }
      # gender(term), ethnicity(term), race(term), event(term)
      define_method(category.to_sym){ |term| self.all_terms.detect{|x| x.category == category && x.term == term.downcase} }
      # gender_id(term), ethnicity_id(term), race_id(term), event_id(term)
      define_method("#{category}_id".to_sym) do |term|
        r = self.all_terms.detect{|x| x.category == category && x.term == term.downcase}
        r.blank? ? nil : r.id
      end
      # gender_ids, ethnicity_ids, race_ids, event_ids
      define_method("#{category}_ids".to_sym){ self.all_terms.select{|x| x.category == category}.map(&:id) }
    end
  end
 
  # Public instance methods
  
  # Instance method to return the 'user readable' value of the term obj
  def to_s
    self.term.to_s
  end

  private
  def downcase_attributes
    self.term.downcase! if self.term
    self.code.downcase! if self.code
    self.category.downcase! if self.category
  end
  
end
