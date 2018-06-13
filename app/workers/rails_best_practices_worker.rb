class RailsBestPracticesWorker
  include Sidekiq::Worker

  def perform(payload)
    RailsBestPracticesCheck.new(payload).check
  end
end
