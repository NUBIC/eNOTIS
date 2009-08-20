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
  #
  def self.lookup_category_terms(cat)
    find(:all, :conditions => ["lower(category)=?",cat.to_s.downcase])
  end

  # Some helper methods than wrap finders
  def self.lookup_code(code, cat)
    find(:first, :conditions => ["lower(code)=? and lower(category)=?",code.to_s.downcase, cat.to_s.downcase])
  end

  def self.lookup_term(term, cat)
    find(:first, :conditions => ["lower(term)=? and lower(category)=?",term.to_s.downcase, cat.to_s.downcase])
  end

  def self.source_terms(source)
    find(:all, :conditions => ["lower(source)=?",source.to_s.downcase])
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
