Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_SERVER', 'redis://no-redis-host-kaputnik:6379') }
end

Sidekiq.configure_client do |config|
  config.redis = { size: 3, url: ENV.fetch('REDIS_SERVER', 'redis://no-redis-host-kaputnik:6379') }
end
