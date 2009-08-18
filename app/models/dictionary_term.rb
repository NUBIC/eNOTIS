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
 
  # Public class methods

  # Some helper methods than wrap finders
  def self.lookup_code(code, cat)
    find(:first, :conditions => ["lower(code)=lower(?) and lower(category)=lower(?)",code.to_s, cat.to_s])
  end

  def self.lookup_term(term, cat)
    find(:first, :conditions => ["lower(term)=lower(?) and lower(category)=lower(?)",term.to_s, cat.to_s])
  end

  def self.source_terms(source)
    find(:all, :conditions => ["lower(source)=lower(?)",source])
  end
 
  # Public instance methods
  
  # Instance method to return the 'user readable' value of the term obj
  def to_s
    self.term.to_s
  end

end
