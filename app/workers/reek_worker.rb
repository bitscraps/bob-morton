class ReekWorker
  include Sidekiq::Worker

  def perform(payload)
    ReekCheck.new(payload).check
  end
end
