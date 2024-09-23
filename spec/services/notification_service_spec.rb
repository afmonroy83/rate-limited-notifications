# spec/services/notification_service_spec.rb
require 'rails_helper'


RSpec.describe NotificationService, type: :service do
  let(:gateway) { instance_double('NotificationGateway') }
  let(:service) { NotificationService.new(gateway) }
  let(:user_id) { 'test@example.com' }

  before do
    allow(gateway).to receive(:send)
  end

  context 'rate limiting' do
    it 'sends the notification if under the limit' do
      expect(gateway).to receive(:send).with(user_id, 'Test message')
      service.send_notification('status', user_id, 'Test message')
    end

    it 'does not send the notification if over the limit' do
      3.times { service.send_notification('status', user_id, 'Test message') }
      expect(gateway).not_to receive(:send).with(user_id, 'Test message')
    end
  end
end
