require 'sidekiq/web'
redis_host = ENV['REDIS_HOST'] || ''
redis_sidekiq_path = ENV['REDIS_SIDEKIQ_PATH'] || '/5/cache'
redis_url = File.join(redis_host, redis_sidekiq_path)

module Sidekiq
  module WebHelpers
    def locale
      'en'
    end
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.log_formatter = Sidekiq::Logger::Formatters::JSON.new
  Rails.logger = config.logger
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
