class RubocopWorker
  include Sidekiq::Worker

  def perform(payload)
    RubocopCheck.new(payload).check
  end
end
