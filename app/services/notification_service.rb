# app/services/notification_service.rb
class NotificationService
  RATE_LIMITS = {
    'status' => { limit: 2, period: 60 }, # 2 per min
    'news' => { limit: 1, period: 24 * 60 * 60 }, # 1 at day
    'marketing' => { limit: 3, period: 60 * 60 } # 3 per hour
  }

  def initialize(gateway = NotificationGateway.new)
    @gateway = gateway
    @redis = Redis.new(host: "redis", port: 6379)
  end

  def send_notification(type, user_id, message)
    rate_limit = RATE_LIMITS[type]
    if rate_limit && over_limit?(type, user_id, rate_limit)
      # If the limit has been exceeded, queue the notification
      wait_time = time_until_limit_resets(type, user_id, rate_limit[:period])
      puts "Rate limit exceeded for #{user_id} on #{type}, re-enqueuing notification in #{wait_time} seconds"

      # Schedule notification to be sent when period passes
      NotificationJob.set(wait: wait_time).perform_later(type, user_id, message)
      return
    end

    # Send notification
    @gateway.send(user_id, message)

    # Increase notification counter
    increment_count(type, user_id, rate_limit[:period]) if rate_limit
  end

  private

  def over_limit?(type, user_id, rate_limit)
    key = "#{user_id}:#{type}"
    count = @redis.get(key).to_i
    count >= rate_limit[:limit]
  end

  def increment_count(type, user_id, period)
    key = "#{user_id}:#{type}"
    @redis.multi do
      @redis.incr(key)
      @redis.expire(key, period)
    end
  end

  # Estimate the time remaining until another notification can be sent
  def time_until_limit_resets(type, user_id, period)
    key = "#{user_id}:#{type}"
    ttl = @redis.ttl(key) # TTL: Time left until the counter expires
    ttl > 0 ? ttl : period
  end

end

