require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Farm2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.time_zone = 'Tokyo'
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/app/services/concerns"]
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths << Rails.root.join("app/decorators/concerns")

    config.action_view.field_error_proc = proc { |html_tag, _instance| "<span class='field_with_errors'>#{html_tag}</span>".html_safe }

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]
    config.active_record.belongs_to_required_by_default = false
    config.active_record.default_timezone = :local

    config.action_controller.include_all_helpers = false

    config.update_logger = Logger.new('log/update_worker.log')
    config.update_logger.level = Logger::INFO
    config.update_logger.formatter = proc do |severity, datetime, _progname, msg|
      action, name, from_hour, to_hour = msg.strip.split(':', 4)
      {
        time: datetime.strftime('%Y-%m-%dT%H:%M:%S%:z'),
        severity: severity,
        action: action,
        worker: name,
        from: from_hour.to_f,
        to: to_hour.to_f
      }.to_json + "\n"
    end

    config.access_logger = Logger.new('log/access_info.log')
    config.access_logger.formatter = proc do |severity, datetime, _progname, msg|
      device, name = msg.strip.split('-', 2)
      {
        time: datetime.strftime('%Y-%m-%dT%H:%M:%S%:z'),
        severity: severity,
        action: 'access',
        device: device,
        user: name
      }.to_json + "\n"
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
  end
end
