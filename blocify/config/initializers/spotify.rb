# Store the environment variables on the Rails.configuration object
 Rails.configuration.spotify = {
   SPOTIFY_CLIENT_ID: ENV['SPOTIFY_CLIENT_ID'],
   SPOTIFY_CLIENT_SECRET: ENV['SPOTIFY_CLIENT_SECRET'],
 }
