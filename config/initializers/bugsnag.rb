Bugsnag.configure do |config|
  config.api_key = ENV.fetch("BUGSNAG_API_KEY")
  config.enabled_release_stages = ["production"]
  config.ignore_classes = [
    "ActiveRecord::RecordNotFound",
    "ActionController::UnknownFormat",
    "ApplicationController::NotAuthorized",
    "SignalException"
  ]
end
