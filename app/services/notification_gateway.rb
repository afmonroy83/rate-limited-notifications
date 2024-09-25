# app/services/notification_gateway.rb
class NotificationGateway
  def send(user_id, message)
    # logic to send de email
    puts "send message to #{user_id}: #{message}"
  end
end
