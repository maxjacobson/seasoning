require "application_system_test_case"

# System test for setting and changing passwords
class PasswordManagementTest < ApplicationSystemTestCase
  test "setting password for passwordless account" do
    human = Human.create!(handle: "bosworth", email: "bosworth@example.com")
    magic_link = MagicLink.create!(email: human.email)

    visit redeem_magic_link_path(magic_link.token)

    click_on "Settings"

    assert_content "You currently sign in with magic links only"

    click_on "Set password"

    fill_in "New password", with: "cardiff-electric-1983"
    fill_in "Confirm new password", with: "cardiff-electric-1983"
    click_on "Save password"

    assert_content "Password saved!"
    assert_content "You have a password set"

    human.reload

    assert_predicate human, :uses_password?
  end

  test "changing existing password" do
    human = Human.create!(
      handle: "haley",
      email: "haley@example.com",
      password: "old-password-here-long",
      password_confirmation: "old-password-here-long"
    )
    magic_link = MagicLink.create!(email: human.email)

    visit redeem_magic_link_path(magic_link.token)

    click_on "Settings"

    assert_content "You have a password set"

    click_on "Change password"

    fill_in "New password", with: "new-password-here-long"
    fill_in "Confirm new password", with: "new-password-here-long"
    click_on "Save password"

    assert_content "Password saved!"

    human.reload

    assert human.authenticate("new-password-here-long")
    assert_not human.authenticate("old-password-here-long")
  end

  test "password edit page has cancel link" do
    human = Human.create!(handle: "donna", email: "donna@example.com")
    magic_link = MagicLink.create!(email: human.email)

    visit redeem_magic_link_path(magic_link.token)

    click_on "Settings"
    click_on "Set password"

    assert_selector "a", text: "Cancel"
  end
end
