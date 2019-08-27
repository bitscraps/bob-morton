class EsLintWorker
  include Sidekiq::Worker

  def perform(payload)
    EsLintCheck.new(payload).check
  end
end
