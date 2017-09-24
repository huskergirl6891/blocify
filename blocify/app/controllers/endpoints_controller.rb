class EndpointsController < ApplicationController

  require 'aws-sdk'
  require 'json'
  require 'rest-client'

  def new
    # Open a AWS ML Realtime Endpoint
    # region = 'us-east-1'
    # aws_client = Aws::MachineLearning::Client.new(region: region)
    # resp = aws_client.create_realtime_endpoint({
    #   ml_model_id: "ml-Syq31owIBgw",
    # })
  end

  def create
    # Open a AWS ML Realtime Endpoint
    region = 'us-east-1'
    aws_client = Aws::MachineLearning::Client.new(region: region)
    resp = aws_client.create_realtime_endpoint({
      ml_model_id: "ml-Syq31owIBgw",
    })

    if resp.realtime_endpoint_info.endpoint_status === "READY" || resp.realtime_endpoint_info.endpoint_status === "UPDATING"
      flash[:notice] = "Endpoint was successfully created."
      redirect_to predictions_path
    else
      flash.now[:alert] = "There was an error creating the endpoint. Please try again."
      redirect_to predictions_path
    end
  end

  def destroy
    # Open a AWS ML Realtime Endpoint
    region = 'us-east-1'
    aws_client = Aws::MachineLearning::Client.new(region: region)
    resp = aws_client.delete_realtime_endpoint({
      ml_model_id: "ml-Syq31owIBgw",
    })

    if resp.realtime_endpoint_info.endpoint_status === "NONE"
      flash[:notice] = "Endpoint was deleted successfully."
      redirect_to predictions_path
    else
      flash.now[:alert] = "There was an error deleting the endpoint."
      redirect_to predictions_path
    end
  end

end
