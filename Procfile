web: bundle exec puma -C config/puma.rb -p $PORT -e ${RACK_ENV:-production}
worker: bundle exec sidekiq -e ${RACK_ENV:-production} -C config/sidekiq.yml -q default