module Bcsec::EnotisUser
  # This module contains methods that will extend the Bcsec::User model
  def studies
    Study.all(:limit => 10)
  end
  def admin?
    permit?(:admin)
  end
  def name
    full_name
  end
  def netid
    username
  end
end