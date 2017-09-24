class PredictionsController < ApplicationController
  require 'aws-sdk'
  require 'json'
  require 'rest-client'

  def index
    @predictions = Prediction.all
  end

  def new
    @prediction = Prediction.new
  end

  def create
    @prediction = Prediction.new

    # authorize Spotify with credentials
    authorize_spotify

    # search for song from user input and store result
    song_info = get_song(params[:prediction][:song])
    @prediction.song = song_info["SongName"]

    # Open a AWS ML Realtime Endpoint
    region = 'us-east-1'
    ml = Aws::MachineLearning::Client.new(region: region)
    resp = ml.create_realtime_endpoint({
      ml_model_id: "ml-Syq31owIBgw",
    })
    endpoint = resp.realtime_endpoint_info.endpoint_url

    # Generate a prediction
    resp2 = ml.predict({
      ml_model_id: "ml-Syq31owIBgw",
      record: {
        "SongID" => "2Oehrcv4Kov0SuIgWyQY9e",
        "SongName" => "Demons",
        "danceability" => "0.327",
        "energy" => "0.71",
        "key" => "3",
        "loudness" => "-2.928",
        "mode" => "1",
        "speechiness" => "0.0547",
        "acousticness" => "0.202",
        "instrumentalness" => "9.00E-05",
        "liveness" => "0.28",
        "valence" => "0.375",
        "tempo" => "179.561"
      },
      #predict_endpoint: "https://realtime.machinelearning.us-east-1.amazonaws.com",
      predict_endpoint: endpoint,
    })

    if resp2.prediction.predicted_label == '1'
      @prediction.result = 1
    elsif resp2.prediction.predicted_label == '0'
      @prediction.result = 0
    else
      @prediction.result = 3
    end

    if @prediction.save
      flash[:notice] = "Prediction was saved."
      redirect_to predictions_path
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def destroy
    @prediction = Prediction.find(params[:id])

    if @prediction.destroy
      flash[:notice] = "Prediction was deleted successfully."
      redirect_to predictions_path
    else
      flash.now[:alert] = "There was an error deleting the prediction."
      redirect_to predictions_path
    end
  end

  def authorize_spotify
    client_token = Base64.strict_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
    spotify_token = RestClient.post("https://accounts.spotify.com/api/token",{"grant_type": "client_credentials"}, {"Authorization": "Basic #{client_token}"})
    @parsed_token = JSON.parse(spotify_token)
  end

  def get_song(text)
    searchURL = "https://api.spotify.com/v1/search?q=#{text}&type=track"
    tracks = RestClient.get(searchURL, {"Authorization": "Bearer #{@parsed_token["access_token"]}"})
    parsed_tracks = JSON.parse(tracks)
    first_song_name = parsed_tracks["tracks"]["items"][0]["name"]
    first_song_id = parsed_tracks["tracks"]["items"][0]["id"]

    searchURL2 = "https://api.spotify.com/v1/audio-features/#{first_song_id}"
    song_attributes = RestClient.get(searchURL2, {"Authorization": "Bearer #{@parsed_token["access_token"]}"})
    parsed_song_attributes = JSON.parse(song_attributes)

    song_data = parsed_song_attributes
    song_data["SongName"] = first_song_name
    puts song_data
    song_data
  end

end
