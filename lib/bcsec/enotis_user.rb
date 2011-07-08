module Bcsec::EnotisUser
  # This module contains methods that will extend the Bcsec::User model
  def studies
    Study.with_user(username)
  end
  def subjects
    Subject.with_user(username)
  end
  def name
    full_name
  end
  def netid
    username
  end
end