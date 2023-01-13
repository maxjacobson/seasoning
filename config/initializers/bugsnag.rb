# frozen_string_literal: true

Bugsnag.configure do |config|
  config.api_key = ENV.fetch("BUGSNAG_API_KEY")
  config.enabled_release_stages = ["production"]
end
