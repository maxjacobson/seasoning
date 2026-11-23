require "application_system_test_case"

# system test for the /admin page
class CheckingAdminStatsTest < ApplicationSystemTestCase
  test "admin can see stats" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "Humans count: 1"
    assert_content "Last active"
    assert_link "cam"
  end

  test "admin sees last active time for humans with my_seasons" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659)
    season = show.seasons.create!(tmdb_id: 60_448, name: "Season 1", season_number: 1, episode_count: 10)
    MySeason.create!(human:, season:)

    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    within(".admin-table") do
      assert_content "less than a minute ago"
    end
  end

  test "admin sees Never for humans without my_seasons" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "Never"
  end

  test "admin can see orphaned seasons count when orphaned seasons exist" do
    human = Human.create!(handle: "donna", email: "donna@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)

    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659)
    show.seasons.create!(tmdb_id: 60_448, name: "Season 1", season_number: 1, episode_count: 10, orphaned: true)

    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "Orphaned seasons count: 1"
    assert_link "Halt and Catch Fire - Season 1"
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
    assert_link "Halt and Catch Fire"
  end

  test "admin does not see orphaned shows count when there are none" do
    human = Human.create!(handle: "bosworth", email: "bosworth@example.com", admin: true)
    @magic_link = MagicLink.create!(email: human.email)

    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_no_content "Orphaned shows count"
  end

  test "admin sees show and review counts for each human" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659)
    season = show.seasons.create!(tmdb_id: 60_448, name: "Season 1", season_number: 1, episode_count: 10)
    MySeason.create!(human:, season:)
    human.my_shows.create!(show:, status: "currently_watching")
    SeasonReview.create!(author: human, season:, viewing: 1, rating: 5, body: "Great")

    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    within(".admin-table") do
      assert_content "Shows added"
      assert_content "Reviews"
      assert_selector("td", text: "1", count: 2)
    end
  end

  test "admin can delete a human who has added no shows" do
    admin = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    Human.create!(handle: "donna", email: "donna@example.com")

    @magic_link = MagicLink.create!(email: admin.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    within("tr", text: "donna") do
      accept_confirm do
        click_on "Delete"
      end
    end

    assert_content "Deleted donna"
    assert_equal 1, Human.count
  end

  test "admin does not see a delete button for themself" do
    admin = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    @magic_link = MagicLink.create!(email: admin.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    within("tr", text: "cam") do
      assert_no_button "Delete"
    end
  end

  test "admin does not see a delete button for humans who have added shows" do
    admin = Human.create!(handle: "cam", email: "cam@example.com", admin: true)
    human = Human.create!(handle: "donna", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659)
    human.my_shows.create!(show:, status: "currently_watching")

    @magic_link = MagicLink.create!(email: admin.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    within("tr", text: "donna") do
      assert_no_button "Delete"
    end
  end

  test "non-admin can't see stats" do
    human = Human.create!(handle: "cam", email: "cam@example.com", admin: false)
    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)
    visit admin_path

    assert_content "401 Unauthorized"
  end
end
