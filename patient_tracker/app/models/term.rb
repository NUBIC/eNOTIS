# 'Dictionary', according to the dictionary, is	a list of codes, 
# terms, keys, etc., and their meanings, used by a computer program or system.
# This class is used a reference for the Clinical terminology of the system, 
# we call it "Term" (with a terms database table) to follow convention but it is essentially a dictionary.

class Term < ActiveRecord::Base

  # Validators
  validates_presence_of :term, :code
  validates_uniqueness_of :term, :scope => :category 
  validates_uniqueness_of :code, :scope => :category
 
  # Some helper methods than wrap finders
  def self.lookup_code(code, cat)
    find(:first, :conditions => ["code=? and category=?",code.to_s, cat.to_s])
  end

  def self.lookup_term(term, cat)
    find(:first, :conditions => ["term=? and category=?",term.to_s, cat.to_s])
  end

  def self.source_terms(source)
    find(:all, :conditions => ["source=?",source])
  end
 
  # Instance method to return the 'user readable' value of the term obj
  def to_s
    self.term.to_s
  end

end
