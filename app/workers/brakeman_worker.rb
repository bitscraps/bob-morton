class BrakemanWorker
  include Sidekiq::Worker

  def perform(payload)
    BrakemanCheck.new(payload).check
  end
end
