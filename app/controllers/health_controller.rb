class HealthController < ApplicationController
  skip_before_action :restrict_remote_ip

  def index
    Rails.application.config.access_logger.info "GS-Health Check"
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    raise "DB not active" unless ActiveRecord::Base.connection.active?
    render json: { status: "ok" }, status: :ok
  rescue StandardError => e
    Rails.logger.error("Health check failed: #{e.message}")
    render json: { status: "error", message: e.message }, status: :service_unavailable
  end
end
