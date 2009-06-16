
# Represents the very strong to very loose affiliation a subject can have with a protocol.
# This abstraction holds data that is associated with a subjects relationship with a protocol
# but is not based around a protocol event. 
# For example: Disease site would be found in the Inolvement join record between a subject and protocol.
# Disease site is a specific piece of data about why the subject is on the trial but not associated with
# a specific event. It is a long term data element that can span the whole relationship of subject and protocol.

class Involvement < ActiveRecord::Base
	belongs_to :subject
	belongs_to :protocol


  def confirmed?
    return self.confirmed
  end

  def confirmed! 
    self.confirmed = true
    self.save
  end
end






