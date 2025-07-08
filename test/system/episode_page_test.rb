require "application_system_test_case"

# System test covering the episode page display
class EpisodePageTest < ApplicationSystemTestCase
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
      episode_count: 10,
      tmdb_id: 62_139,
      slug: "season-1"
    )
    @episode = Episode.create!(
      season: @season,
      name: "I/O",
      episode_number: 1,
      tmdb_id: 976_455,
      air_date: Date.new(2014, 6, 1),
      still_path: "/6lWCAwVqOXdTB7ay5MIjff0rGpB.jpg"
    )

    @my_show = MyShow.create!(
      human: @human,
      show: @show,
      status: "currently_watching"
    )
  end

  test "visiting episode page shows episode information" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "I/O"

    assert page.has_content?("I/O")
    assert page.has_content?("An episode of Halt and Catch Fire")
    assert page.has_content?("Season 1")
    assert page.has_content?("06/01/2014")
    assert page.has_content?("More info")
    assert page.has_content?("FYI")
    assert page.has_content?("Data last refreshed:")
    assert page.has_content?("Data will next be refreshed within 24 hours of")

    assert page.has_link?("Halt and Catch Fire", href: "/shows/halt-and-catch-fire")
    assert page.has_link?("Season 1", href: "/shows/halt-and-catch-fire/season-1")
    assert page.has_link?("More info", href: "https://www.themoviedb.org/tv/59659/season/1/episode/1")
  end

  test "visiting episode page with future air date shows grayed out date" do
    @episode.update!(air_date: Date.tomorrow)

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "I/O"

    assert page.has_content?("I/O")
    formatted_date = Date.tomorrow.strftime("%m/%d/%Y")

    assert page.has_content?(formatted_date)
  end

  test "visiting episode page with no air date shows dash" do
    @episode.update!(air_date: nil)

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "I/O"

    assert page.has_content?("I/O")
    assert page.has_content?("—")
  end

  test "visiting episode page with no still image works" do
    @episode.update!(still_path: nil)

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "I/O"

    assert page.has_content?("I/O")
    assert page.has_content?("An episode of Halt and Catch Fire")
  end
end
