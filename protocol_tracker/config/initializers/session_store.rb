# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_protocol_tracker_session',
  :secret      => 'd0754eb37f3ff7c372427a74b5c6259fa6e86f5f0213f33c8220cedc8651c2ba97ee879a53b0565e875291f7c1f5fd6c3a118578508f9c35efe600f496dd1d87'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
