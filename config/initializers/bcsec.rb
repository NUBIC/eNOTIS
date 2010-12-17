require 'lib/bcsec/modes/enotis_front'
Bcsec.configure do
  # The authentication protocol to use for interactive access.
  # `:form` is the default.
  ui_mode :enotis_front

  # The authentication protocol(s) to use for non-interactive
  # access.  There is no default.
  api_mode :cas_proxy

  # The portal to which this application belongs.  Optional.
  portal :eNOTIS # should match PORTAL in lib/users_to_pers.rb
end
