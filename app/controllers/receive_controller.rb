class ReceiveController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    payload = JSON.parse(params[:payload])

    if payload['action'] == 'opened' || payload['action'] == 'synchronize'
      RubocopWorker.perform_async(payload)
      BrakemanWorker.perform_async(payload)
      # RailsBestPracticesWorker.perform_async(payload)
      job = 'opened'
    end

    render plain: "Job #{job} kicked off"
  end
end
