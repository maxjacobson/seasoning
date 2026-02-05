require "application_system_test_case"

class DeletingOrphanedSeasonTest < ApplicationSystemTestCase
  setup do
    @show = Show.create!(
      title: "Halt and Catch Fire",
      tmdb_tv_id: 59_659,
      tmdb_last_refreshed_at: 1.day.ago,
      tmdb_next_refresh_at: 1.day.from_now
    )
    @season = @show.seasons.create!(
      name: "Season 1",
      season_number: 1,
      episode_count: 1,
      tmdb_id: 62_139,
      orphaned: true
    )
    @episode = Episode.create!(
      season: @season,
      name: "I/O",
      episode_number: 1,
      tmdb_id: 976_455
    )
  end

  test "admin can delete an orphaned season" do
    human = Human.create!(handle: "donna", email: "donna@example.com", admin: true)
    MyShow.create!(human: human, show: @show, status: "currently_watching")
    magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(magic_link.token)

    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert_content "This season is orphaned"

    accept_confirm do
      click_on "Delete season"
    end

    assert_content "Deleted Season 1"
    assert_content "No seasons..."
    assert_equal 0, @show.seasons.count
    assert_equal 0, Episode.where(season: @season).count
  end

  test "delete button is disabled when the season has reviews" do
    human = Human.create!(handle: "gordon", email: "gordon@example.com", admin: true)
    MyShow.create!(human: human, show: @show, status: "currently_watching")
    magic_link = MagicLink.create!(email: human.email)

    SeasonReview.create!(
      author: human,
      season: @season,
      body: "Great season!",
      viewing: 1,
      visibility: "anybody"
    )

    visit redeem_magic_link_path(magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert_content "This season is orphaned"
    button = find_button("Delete season", disabled: true)

    assert_equal "Cannot delete a season that has reviews", button["title"]
  end

  test "non-admin does not see delete button" do
    human = Human.create!(handle: "cameron", email: "cameron@example.com", admin: false)
    MyShow.create!(human: human, show: @show, status: "currently_watching")
    magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(magic_link.token)

    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert_content "This season is orphaned"
    assert_no_button "Delete season"
  end
end
