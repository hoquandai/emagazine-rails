require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EmagazineRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    redis_path = ENV['REDIS_CACHE_PATH'] || '/0/cache'
    redis_host = ENV['REDIS_HOST'] || ''
    config.redis_url = File.join(redis_host, redis_path)
    cache_servers = [config.redis_url]

    config.cache_store = :redis_cache_store, {
      url: cache_servers,

      connect_timeout: 30,
      expires_in: 6.hours,
      race_condition_ttl: 3.seconds
    }
    config.active_job.queue_adapter = :sidekiq
  end
end
