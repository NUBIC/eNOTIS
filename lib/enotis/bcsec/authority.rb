class Enotis::Bcsec::Authority
  # This authority decorates the Bcsec::User model with extra methods from the Enotis::EnotisUser module
  def amplify!(user)
    return user.extend Enotis::EnotisUser
  end
end