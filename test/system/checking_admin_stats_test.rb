require "application_system_test_case"

# system test for the /admin page
class CheckingAdminStatsTest < ApplicationSystemTestCase
  test "admin can see stats" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "Humans count: 1"
  end

  test "non-admin can't see stats" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: false)
    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "401 Unauthorized"
  end
end
