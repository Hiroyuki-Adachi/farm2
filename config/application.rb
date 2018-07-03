require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Farm2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_view.field_error_proc = proc { |html_tag, _instance| "<span class='field_with_errors'>#{html_tag}</span>".html_safe }

    config.i18n.default_locale = :ja
    config.active_record.belongs_to_required_by_default = false

    config.update_logger = Logger.new('log/update_worker.log', 'monthly')
    config.update_logger.formatter = proc do |_severity, datetime, _progname, msg|
      "#{datetime}: #{msg}\n"
    end
  end
end
