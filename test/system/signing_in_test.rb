require "application_system_test_case"

# System test covering the sign in flow
class SigningInTest < ApplicationSystemTestCase
  setup do
    Human.create!(handle: "donna", email: "donna@example.com")
  end

  test "signing in test" do
    visit root_path
    click_link "Sign in"

    within "[data-test-id='magic-link-section']" do
      fill_in "Email", with: "donna@example.com"
      click_on "Send magic link"
    end

    assert_content "Check your email"

    assert_equal 1, MagicLinkMailer.deliveries.count
    assert_equal 1, MagicLink.count
    token = MagicLink.first!.token

    email = MagicLinkMailer.deliveries.first

    assert_includes email.to_s, "Welcome back to Seasoning"

    assert_match %r{http://127.0.0.1:57081/knock-knock/(#{token})}, email.to_s

    visit redeem_magic_link_path(token)

    assert_content "No shows yet"
    assert_equal "/shows", page.current_path
  end

  test "an expired magic link" do
    visit root_path
    click_link "Sign in"

    within "[data-test-id='magic-link-section']" do
      fill_in "Email", with: "donna@example.com"
      click_on "Send magic link"
    end

    assert_content "Check your email"

    assert_equal 1, MagicLinkMailer.deliveries.count
    assert_equal 1, MagicLink.count
    token = MagicLink.first!.token

    email = MagicLinkMailer.deliveries.first

    assert_includes email.to_s, "Welcome back to Seasoning"

    assert_match %r{http://127.0.0.1:57081/knock-knock/(#{token})}, email.to_s

    # simulating prune:all running
    MagicLink.destroy_all

    visit redeem_magic_link_path(token)

    assert_content "Hmm, that magic link does not seem to be valid."
  end
end
