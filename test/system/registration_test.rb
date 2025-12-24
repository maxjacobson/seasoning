require "application_system_test_case"

# System test covering the human registration flow
class RegistrationTest < ApplicationSystemTestCase
  test "registering with valid email" do
    visit root_path
    click_link "Sign up"

    within "[data-test-id='signup-form']" do
      fill_in "Email", with: "donna@example.com"
      click_on "Send magic link"
    end

    assert_content "Check your email"

    assert_equal 1, MagicLinkMailer.deliveries.count
    assert_equal 1, MagicLink.count
    token = MagicLink.first!.token

    email = MagicLinkMailer.deliveries.first

    assert_includes email.to_s, "Click the link below to finish the sign up process and start adding your shows"

    assert_match %r{http://127.0.0.1:57081/knock-knock/(#{token})}, email.to_s

    visit redeem_magic_link_path(token)

    assert_content "Complete your sign up"
    fill_in "Your handle", with: "donna"
    click_on "Go"

    assert_content "No shows yet"
    assert_equal "/shows", page.current_path
  end

  test "registering with invalid email" do
    visit root_path
    click_link "Sign up"

    within "[data-test-id='signup-form']" do
      fill_in "Email", with: "donna"
      click_on "Send magic link"
    end

    assert_content "Email is invalid"
  end
end
