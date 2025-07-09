require "application_system_test_case"

# System test covering the season page display and episode marking
class SeasonPageTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "donna",
      email: "donna@example.com",
      default_review_visibility: "anybody"
    )
    @magic_link = MagicLink.create!(email: @human.email)

    @show = Show.create!(
      title: "Halt and Catch Fire",
      tmdb_tv_id: 59_659,
      slug: "halt-and-catch-fire",
      tmdb_last_refreshed_at: 1.day.ago,
      tmdb_next_refresh_at: 1.day.from_now
    )
    @season = Season.create!(
      show: @show,
      name: "Season 1",
      season_number: 1,
      episode_count: 3,
      tmdb_id: 62_139,
      slug: "season-1"
    )

    @episode1 = Episode.create!(
      season: @season,
      name: "I/O",
      episode_number: 1,
      tmdb_id: 976_455,
      air_date: Date.new(2014, 6, 1),
      still_path: "/6lWCAwVqOXdTB7ay5MIjff0rGpB.jpg"
    )

    @episode2 = Episode.create!(
      season: @season,
      name: "FUD",
      episode_number: 2,
      tmdb_id: 976_456,
      air_date: Date.new(2014, 6, 8)
    )

    @episode3 = Episode.create!(
      season: @season,
      name: "High Plains Hardware",
      episode_number: 3,
      tmdb_id: 976_457,
      air_date: Date.new(2014, 6, 15)
    )

    @my_show = MyShow.create!(
      human: @human,
      show: @show,
      status: "currently_watching"
    )
  end

  test "visiting season page shows season information" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert page.has_content?("Halt and Catch Fire")
    assert page.has_content?("Season 1")
    assert page.has_content?("More info")
    assert page.has_content?("Back")
    assert page.has_content?("Season info")
    assert page.has_content?("I/O")
    assert page.has_content?("FUD")
    assert page.has_content?("High Plains Hardware")
    assert page.has_content?("06/01/2014")
    assert page.has_content?("06/08/2014")
    assert page.has_content?("06/15/2014")
    assert page.has_content?("FYI")
    assert page.has_content?("Data last refreshed:")

    assert page.has_link?("Back", href: "/shows/halt-and-catch-fire")
    assert page.has_link?("More info", href: "https://www.themoviedb.org/tv/59659/season/1")
    assert page.has_link?("I/O", href: "/shows/halt-and-catch-fire/season-1/1")
    assert page.has_link?("FUD", href: "/shows/halt-and-catch-fire/season-1/2")
    assert page.has_link?("High Plains Hardware", href: "/shows/halt-and-catch-fire/season-1/3")
  end

  test "marking episode as seen" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert page.has_button?("Mark seen")
    first("input[value='Mark seen']").click

    assert page.has_content?("I/O marked as seen")
    assert page.has_button?("Mark not seen")
    assert page.has_content?("✅")

    my_season = MySeason.find_by(human: @human, season: @season)

    assert_includes my_season.watched_episode_numbers, 1
  end

  test "marking episode as not seen" do
    my_season = MySeason.create!(human: @human, season: @season, watched_episode_numbers: [1, 2])

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert page.has_button?("Mark not seen")
    assert page.has_content?("✅")
    first("input[value='Mark not seen']").click

    assert page.has_content?("I/O marked as not seen")
    assert page.has_button?("Mark seen")

    my_season.reload

    assert_not_includes my_season.watched_episode_numbers, 1
    assert_includes my_season.watched_episode_numbers, 2
  end

  test "season page shows review section when authenticated" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert page.has_content?("Your review")
    assert page.has_content?("Add review")
    assert page.has_content?("None yet")
    assert page.has_link?("Add review", href: "/shows/halt-and-catch-fire/season-1/reviews/new")
  end

  test "season page shows existing reviews" do
    review = SeasonReview.create!(
      author: @human,
      season: @season,
      body: "Great season!",
      rating: 9,
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert page.has_content?("Your review")
    assert page.has_link?(review.created_at.to_date.to_s, href: "/donna/shows/halt-and-catch-fire/season-1")
  end
end
