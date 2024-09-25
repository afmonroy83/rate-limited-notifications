# spec/services/notification_service_spec.rb
require 'rails_helper'

RSpec.describe NotificationService, type: :service do
  let(:gateway) { instance_double("NotificationGateway") }
  let(:service) { NotificationService.new(gateway) }
  let(:user_id) { "test@example.com" }
  let(:redis) { Redis.new(host: "redis", port: 6379) }

  before do
    allow(gateway).to receive(:send)
    redis.flushdb  # Clear Redis before each test to avoid residual data
  end

  after do
    redis.flushdb  # Clean up Redis after each test
  end

  context "when rate limit is not exceeded" do
    it "sends the notification" do
      expect(gateway).to receive(:send).with(user_id, "Test message")
      service.send_notification("status", user_id, "Test message")
    end

    it "increments the notification count in Redis" do
      service.send_notification("status", user_id, "Test message")
      expect(redis.get("#{user_id}:status").to_i).to eq(1)
    end
  end

  context "when rate limit is exceeded" do
    it "does not send the notification if the limit is exceeded" do
      # Simulate sending two notifications to hit the limit
      2.times { service.send_notification("status", user_id, "Test message") }

      # The third attempt should exceed the limit and not send the notification
      expect(gateway).not_to receive(:send).with(user_id, "Test message")
      service.send_notification("status", user_id, "Test message")
    end

    it "enqueues the notification when the limit is exceeded" do
      # Simulate sending two notifications to hit the limit
      2.times { service.send_notification("status", user_id, "Test message") }

      # Ensure a job is enqueued when the limit is exceeded
      expect {
        service.send_notification("status", user_id, "Test message")
      }.to have_enqueued_job(NotificationJob).with("status", user_id, "Test message")
    end
  end

  context "when rate limit is reset" do
    it "allows sending a notification after the limit resets" do
      # Send 2 notifications to reach the limit
      2.times { service.send_notification("status", user_id, "Test message") }

      # Simulate the rate limit period expiring (manually expire the Redis key)
      redis.expire("#{user_id}:status", 0)

      # A new notification should be allowed after the limit resets
      expect(gateway).to receive(:send).with(user_id, "Test message")
      service.send_notification("status", user_id, "Test message")
    end
  end
end
