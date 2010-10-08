# require 'bcsec/enotis_user'
class Bcsec::Authorities::Enotis
  # This authority decorates the Bcsec::User model with extra methods from the Bcsec::EnotisUser module
  def amplify!(user)
    return user.extend(Bcsec::EnotisUser)
  end
end