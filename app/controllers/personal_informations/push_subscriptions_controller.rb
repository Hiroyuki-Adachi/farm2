class PersonalInformations::PushSubscriptionsController < PersonalInformationsController
  def create
    return render json: { error: "web push not configured" }, status: :service_unavailable unless WebPushService.configured?

    subscription = @current_user.web_push_subscriptions.find_or_initialize_by(endpoint: subscription_params[:endpoint])
    subscription.assign_attributes(subscription_params)
    subscription.save!
    @current_user.update!(push_notification_permission: "granted", push_notification_requested_at: Time.current)

    render json: { status: "ok" }
  end

  def destroy
    @current_user.web_push_subscriptions.destroy_all
    render json: { status: "ok" }
  end

  def permission
    permission = params.require(:permission)
    unless %w[default granted denied unsupported].include?(permission)
      return render json: { error: "invalid permission" }, status: :unprocessable_entity
    end

    @current_user.update!(push_notification_permission: permission, push_notification_requested_at: Time.current)
    @current_user.web_push_subscriptions.destroy_all unless permission == "granted"

    render json: { status: "ok" }
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, :p256dh, :auth, :expiration_time, :user_agent)
  end
end
