require "application_system_test_case"

# System test covering signing out flow
class SigningOutTest < ApplicationSystemTestCase
  setup do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    @magic_link = MagicLink.create!(email: human.email)
  end

  test "signing out" do
    visit redeem_magic_link_path(@magic_link.token)

    assert_content "No shows yet"

    accept_confirm do
      click_on "Log out"
    end

    assert_content "survive the age of Peak TV"
  end
end
