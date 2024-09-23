# app/services/notification_gateway.rb
class NotificationGateway
  def send(user_id, message)
    # logic to send de email
    puts "Enviando mensaje a #{user_id}: #{message}"
  end
end
