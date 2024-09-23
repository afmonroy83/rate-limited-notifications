class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    type = notification_params[:type]
    user_id = notification_params[:user_id]
    message = notification_params[:message]

    NotificationJob.perform_later(type, user_id, message)

    render json: { status: 'Notification scheduled' }, status: :ok
  end

  private

  # Define only allowed params
  def notification_params
    params.require(:notification).permit(:type, :user_id, :message)
  end

  def parameter_missing(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end

end
