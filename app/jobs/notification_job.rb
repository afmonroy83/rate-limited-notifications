# app/jobs/notification_job.rb
class NotificationJob < ApplicationJob
  queue_as :default

  def perform(type, user_id, message)
    NotificationService.new.send_notification(type, user_id, message)
  end
end
