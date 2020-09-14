require_relative 'boot'

# require 'rails/all'
require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Farm2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Tokyo'
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_view.field_error_proc = proc { |html_tag, _instance| "<span class='field_with_errors'>#{html_tag}</span>".html_safe }

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.active_record.belongs_to_required_by_default = false
    config.active_record.default_timezone = :local

    config.action_controller.include_all_helpers = false

    config.active_job.queue_adapter = :delayed_job

    config.update_logger = Logger.new('log/update_worker.log', 'monthly')
    config.update_logger.formatter = proc do |_severity, datetime, _progname, msg|
      "#{datetime}: #{msg}\n"
    end

    config.access_logger = Logger.new('log/access_info.log', 'monthly')
    config.access_logger.formatter = proc do |_severity, datetime, _progname, msg|
      "#{datetime}: #{msg}\n"
    end
  end
end
