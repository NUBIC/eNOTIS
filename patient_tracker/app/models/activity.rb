class Activity < ActiveRecord::Base
  def whodunnit=(who)
    who.respond_to?(:netid) ? who.netid : who
  end
end
