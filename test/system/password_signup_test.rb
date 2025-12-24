require "application_system_test_case"

# System test covering signup with optional password
class PasswordSignupTest < ApplicationSystemTestCase
  test "registering with password" do
    visit root_path
    click_link "Sign up"

    within "[data-test-id='signup-form']" do
      fill_in "Email", with: "cameron@example.com"
      click_on "Send magic link"
    end

    assert_content "Check your email"

    token = MagicLink.find_by!(email: "cameron@example.com").token
    visit redeem_magic_link_path(token)

    assert_content "Complete your sign up"

    fill_in "Your handle", with: "cameron"
    fill_in "Password (optional)", with: "mutiny-forever-1985"
    fill_in "Confirm password", with: "mutiny-forever-1985"
    click_on "Go"

    assert_content "No shows yet"

    cameron = Human.find_by!(handle: "cameron")

    assert_predicate cameron, :uses_password?
    assert cameron.authenticate("mutiny-forever-1985")
  end

  test "registering without password (passwordless)" do
    visit root_path
    click_link "Sign up"

    within "[data-test-id='signup-form']" do
      fill_in "Email", with: "gordon@example.com"
      click_on "Send magic link"
    end

    assert_content "Check your email"

    token = MagicLink.find_by!(email: "gordon@example.com").token
    visit redeem_magic_link_path(token)

    fill_in "Your handle", with: "gordon"
    click_on "Go"

    assert_content "No shows yet"

    gordon = Human.find_by!(handle: "gordon")

    assert_not gordon.uses_password?
  end

  test "password must be at least 12 characters" do
    visit root_path
    click_link "Sign up"

    within "[data-test-id='signup-form']" do
      fill_in "Email", with: "joe@example.com"
      click_on "Send magic link"
    end

    assert_content "Check your email"

    token = MagicLink.find_by!(email: "joe@example.com").token
    visit redeem_magic_link_path(token)

    fill_in "Your handle", with: "joe"
    fill_in "Password (optional)", with: "short"
    fill_in "Confirm password", with: "short"
    click_on "Go"

    assert_content "Password is too short"
  end

  test "password confirmation must match" do
    visit root_path
    click_link "Sign up"

    within "[data-test-id='signup-form']" do
      fill_in "Email", with: "joanie@example.com"
      click_on "Send magic link"
    end

    assert_content "Check your email"

    token = MagicLink.find_by!(email: "joanie@example.com").token
    visit redeem_magic_link_path(token)

    fill_in "Your handle", with: "joanie"
    fill_in "Password (optional)", with: "long-enough-password-here"
    fill_in "Confirm password", with: "different-password"
    click_on "Go"

    assert_content "Password confirmation doesn't match"
  end
end
