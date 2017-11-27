class ReceiveController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receive
    payload = JSON.parse(params[:payload])

    if payload['action'] == 'opened' || payload['action'] == 'synchronize'
      RubocopWorker.perform_async(payload)
      # BrakemanWorker.perform_async(payload)
      job = 'opened'
    end

    render text: "Job #{job} kicked off"
  end
end
