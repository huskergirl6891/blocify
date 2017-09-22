class PredictionsController < ApplicationController
  require 'aws-sdk'
  require 'rspotify'

  def index
    @predictions = Prediction.all
  end

  def new
    @prediction = Prediction.new
  end

  def create
    @prediction = Prediction.new
    @prediction.song = params[:prediction][:song]

    # # Find Spotify song from user input
    # RSpotify.authenticate("1af6192ff1eb4ab78a54e772f2956105", "111bee776bc9497d8064d222a2a3ce93")
    #
    # sorry = RSpotify::Track.search("Sorry").first
    # @prediction.song = sorry.name

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
        "SongID" => "0HcSC0BbA1H5zwGCr9xCON",
        "SongName" => "I Want It That Way",
        "danceability" => "0.687",
        "energy" => "0.7",
        "key" => "6",
        "loudness" => "-5.74",
        "mode" => "0",
        "speechiness" => "0.0264",
        "acousticness" => "0.246",
        "instrumentalness" => "0",
        "liveness" => "0.233",
        "valence" => "0.488",
        "tempo" => "99.042"
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
end
