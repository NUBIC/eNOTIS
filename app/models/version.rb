# This model is used to customize whodunnit
# in the paper_trail gem. Instead of recording 
# the User object, record the user's netid

class Version < ActiveRecord::Base
  
  # Public instance methods
  def whodunnit=(who)
    who.respond_to?(:netid) ? who.netid : who
  end
end
