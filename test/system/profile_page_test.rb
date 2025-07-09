require "application_system_test_case"

# System test covering viewing and upating settings
class ProfilePageTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "cam",
      email: "cam@example.com"
    )
    @magic_link = MagicLink.create!(email: @human.email)
  end

  test "page can load" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Your page"

    assert_content "cam is not currently watching anything"
    assert_equal "/cam", page.current_path
  end
end
