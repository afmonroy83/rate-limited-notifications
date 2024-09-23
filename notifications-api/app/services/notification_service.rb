# app/services/notification_service.rb
class NotificationService
  RATE_LIMITS = {
    'status' => { limit: 2, period: 60 }, # 2 per min
    'news' => { limit: 1, period: 24 * 60 * 60 }, # 1 at day
    'marketing' => { limit: 3, period: 60 * 60 } # 3 per hour
  }

  def initialize(gateway = NotificationGateway.new)
    @gateway = gateway
    @redis = Redis.new
  end

  def send_notification(type, user_id, message)
    rate_limit = RATE_LIMITS[type]
    if rate_limit && over_limit?(type, user_id, rate_limit)
      puts "Rate limit exceeded for #{user_id} on #{type}"
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
end

