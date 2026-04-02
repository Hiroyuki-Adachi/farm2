require "webpush"

class WebPushService
  class << self
    def configured?
      vapid_public_key.present? && vapid_private_key.present?
    end

    def vapid_public_key
      Rails.application.credentials.dig(:web_push, :public_key)
    end

    def push(subscription, payload)
      return false unless configured?

      Webpush.payload_send(
        message: payload.to_json,
        endpoint: subscription.endpoint,
        p256dh: subscription.p256dh,
        auth: subscription.auth,
        ttl: 24.hours.to_i,
        vapid: {
          subject: vapid_subject,
          public_key: vapid_public_key,
          private_key: vapid_private_key
        }
      )
      subscription.touch(:last_used_at)
      true
    rescue Webpush::ExpiredSubscription, Webpush::InvalidSubscription, Webpush::ResponseError => e
      Rails.logger.warn("[WebPush] subscription expired endpoint=#{subscription.endpoint} error=#{e.class}")
      subscription.destroy!
      false
    rescue StandardError => e
      Rails.logger.error("[WebPush] push failed endpoint=#{subscription.endpoint} error=#{e.class} message=#{e.message}")
      false
    end

    private

    def vapid_private_key
      Rails.application.credentials.dig(:web_push, :private_key)
    end

    def vapid_subject
      Rails.application.credentials.dig(:web_push, :subject) || "mailto:admin@example.com"
    end
  end
end
