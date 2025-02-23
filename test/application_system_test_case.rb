require "test_helper"

# Setup for system tests
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driver = if ENV["CI"] || ENV["HEADLESS"] == "1"
             :headless_chrome
           else
             :chrome
           end
  driven_by :selenium, using: driver, screen_size: [1400, 1400]

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
