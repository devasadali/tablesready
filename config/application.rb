require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReadyText
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.stripe.secret_key = ENV["STRIPE_SECRET_KEY"]
    config.stripe.publishable_key = ENV["STRIPE_PUBLISHABLE_KEY"]
    config.time_zone = "UTC"
    config.active_job.queue_adapter = :delayed_job
    config.exceptions_app = self.routes
  end
end
