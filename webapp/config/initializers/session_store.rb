# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_webapp_session',
  :secret      => '62c74c8d8222f627a1935a4c6a63f825c8919c6d2ccfe8524cdb72aeeaee4eeaf375822cf93d016ae24f0e651626fbea1c331c0034ead213206805ed3612c916'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
