require "application_system_test_case"

# System test covering signing out flow
class SigningOutTest < ApplicationSystemTestCase
  setup do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    @magic_link = MagicLink.create!(email: human.email)
  end

  test "signing out" do
    visit redeem_magic_link_path(@magic_link.token)

    assert page.has_content?("No shows yet")
    click_on "Log out"
    accept_alert

    assert page.has_content?("This is seasoning, a website about TV shows")
  end
end
