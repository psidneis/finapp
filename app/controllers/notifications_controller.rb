class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show, :destroy]
  after_action :verify_authorized, except: [:index]

  respond_to :html

  def index
    @notifications = policy_scope(Notification)
    respond_with(@notifications)
  end

  def show
    @notification.update_attribute(:check, true)
    respond_with(@notification)
  end

  def destroy
    @notification.destroy
    respond_with(@notification)
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
      authorize @notification
    end

    def notification_params
      params.require(:notification).permit(:user_id, :title, :description, :url, :check, :icon)
    end
end
