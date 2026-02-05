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

  test "admin can see orphaned seasons count when orphaned seasons exist" do
    human = Human.create!(handle: "donna", email: "donna@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)

    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659)
    show.seasons.create!(tmdb_id: 60_448, name: "Season 1", season_number: 1, episode_count: 10, orphaned: true)

    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "Orphaned seasons count: 1"
  end

  test "admin does not see orphaned seasons count when there are none" do
    human = Human.create!(handle: "gordon", email: "gordon@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)

    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_no_content "Orphaned seasons count"
  end

  test "admin can see orphaned shows count when orphaned shows exist" do
    human = Human.create!(handle: "joe", email: "joe@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)

    Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, orphaned: true)

    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "Orphaned shows count: 1"
  end

  test "admin does not see orphaned shows count when there are none" do
    human = Human.create!(handle: "bosworth", email: "bosworth@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)

    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_no_content "Orphaned shows count"
  end

  test "non-admin can't see stats" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: false)
    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "401 Unauthorized"
  end
end
