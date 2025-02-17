require "application_system_test_case"

# System test covering the human registration flow
class RegistrationTest < ApplicationSystemTestCase
  test "registering" do
    visit root_path
    fill_in "email", with: "donna@example.com"
    click_on "Go"

    assert page.has_content?("Check your email")

    assert_equal 1, MagicLinkMailer.deliveries.count
    assert_equal 1, MagicLink.count
    token = MagicLink.first!.token

    email = MagicLinkMailer.deliveries.first

    assert_includes email.to_s, "Click the link below to finish the sign up process and start adding your shows"

    assert_match %r{http://127.0.0.1:57081/knock-knock/(#{token})}, email.to_s

    visit "/knock-knock/#{token}"

    assert page.has_content?("Complete your sign up")
    fill_in "handle", with: "donna"
    click_on "Go"

    assert page.has_content?("No shows yet")
    assert_equal "/shows", page.current_path
  end
end
