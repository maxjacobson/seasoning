require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Seasoning
  # The rack app
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#new-activesupport-cache-serialization-format
    config.active_support.cache_format_version = 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_support.to_time_preserves_timezone = :zone

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.action_dispatch.rescue_responses.merge!(
      "ApplicationController::NotAuthorized" => :unauthorized
    )

    # Disabling CSRF protection. This is a single page app which uses a JSON API
    # to access/manipulate data. As long as the request has a valid token,
    # we're good
    config.action_controller.allow_forgery_protection = false
  end
end
