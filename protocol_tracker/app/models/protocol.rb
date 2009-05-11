class Protocol < ActiveRecord::Base
  include EirbServices

  def self.find_status(id)
    self.eirb_search(:idStatus, {:ID => id})
  end
end
