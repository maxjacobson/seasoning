Bugsnag.configure do |config|
  config.api_key = ENV.fetch("BUGSNAG_API_KEY")
  config.enabled_release_stages = ["production"]
  config.app_version = ENV.fetch("HEROKU_RELEASE_VERSION", nil)
  config.ignore_classes = [
    ActionController::UnknownFormat
  ]
end
