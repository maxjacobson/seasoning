require "test_helper"

Capybara.register_driver :my_playwright do |app|
  Capybara::Playwright::Driver.new(app,
                                   browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
                                   headless: (false unless ENV["CI"] || ENV["HEADLESS"]))
end

# Setup for system tests
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :my_playwright

  def setup
    Capybara.server = :puma, { Silent: true }
    Capybara.default_max_wait_time = 10
    super
  end

  def teardown
    ActionMailer::Base.deliveries.clear

    super
  end
end
