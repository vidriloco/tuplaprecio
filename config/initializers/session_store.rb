# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tuplaprecio_session',
  :secret      => '34b68805105b2af9c071216b6f2ab4c0a2679bd6f93368d8cd2d270ea3feea182ba05406046655888b6cc06b84d7d960e5999432a480830f53cf6c72f09a6105'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
