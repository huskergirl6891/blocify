# Store the environment variables on the Rails.configuration object
 Rails.configuration.spotify = {
   spotify_client_id: ENV['SPOTIFY_CLIENT_ID'],
   spotify_client_secret: ENV['SPOTIFY_CLIENT_SECRET'],
 }

 #RSpotify.authenticate(Rails.configuration.spotify[:spotify_client_id], Rails.configuration.spotify[:spotify_client_secret])
