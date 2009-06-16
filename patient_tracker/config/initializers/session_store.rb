# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_subject_tracker_session',
  :secret      => '5ce08b00698f0119178e0d16f0d9cc73a7d2f9150f39a38bbe94414bdf838b27829e34273b1b622c3f923f4921ada8d867531cc1571f5793b7ccf763c2625adc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
