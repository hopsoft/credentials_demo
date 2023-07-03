require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CredentialsDemo
  class Application < Rails::Application
    creds = credentials[:shared]
      .merge(credentials[Rails.env.to_sym])
      .with_indifferent_access
      .transform_keys(&:upcase)
      .transform_values(&:to_s)
    ap creds
    ENV.merge! creds.merge(ENV)

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
