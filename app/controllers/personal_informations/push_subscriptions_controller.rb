class PersonalInformations::PushSubscriptionsController < PersonalInformationsController
  def create
    return render json: { error: "web push not configured" }, status: :service_unavailable unless WebPushService.configured?

    begin
      WebPushSubscription.transaction do
        subscription = WebPushSubscription.find_or_initialize_by(endpoint: subscription_params[:endpoint])
        subscription.assign_attributes(subscription_params)
        subscription.user = @current_user
        subscription.save!

        @current_user.update!(push_notification_permission: "granted", push_notification_requested_at: Time.current)
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
      error_messages =
        if e.respond_to?(:record) && e.record && e.record.respond_to?(:errors)
          e.record.errors.full_messages
        else
          [e.message]
        end
      return render json: { error: error_messages }, status: :unprocessable_entity
    end
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
