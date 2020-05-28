require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { size: 4 }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['SIDEKIQ_USERNAME'], ENV['SIDEKIQ_PASSWORD']]
end

if Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline! unless Rails.env.test?
end