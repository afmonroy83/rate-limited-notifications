redis_url = ENV.fetch('REDIS_SERVER') { 'redis://localhost:6379/1' }

$redis = Redis.new(url: redis_url)

# Para asegurarte de que Sidekiq use Redis correctamente, si lo estás usando:
Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
