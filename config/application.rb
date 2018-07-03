require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Farm2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.update_logger = Logger.new('log/update_worker.log', 'monthly')
    config.update_logger.formatter = proc do |_severity, datetime, _progname, msg|
      "#{datetime}: #{msg}\n"
    end
  end
end
