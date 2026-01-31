require "application_system_test_case"

# System test covering skipping/unskipping seasons
class SkippingSeasonsTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "gordon",
      email: "gordon@example.com",
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
      air_date: Date.new(2014, 6, 1)
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

  test "season page shows skip checkbox when authenticated" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert_content "Skip this season"

    skip_checkbox = find("input[type='checkbox'][name='skipped']")

    assert_not_predicate skip_checkbox, :checked?
  end

  test "marking season as skipped disables episode checkboxes" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    episode_checkbox = first("input[type='checkbox'][name='watched']")

    assert_not_predicate episode_checkbox, :disabled?

    skip_checkbox = find("input[type='checkbox'][name='skipped']")
    skip_checkbox.check

    assert_content "Season 1 marked as skipped"

    episode_checkbox = first("input[type='checkbox'][name='watched']")

    assert_predicate episode_checkbox, :disabled?
  end

  test "marking season as skipped hides progress bar" do
    MySeason.create!(human: @human, season: @season, watched_episode_numbers: [1])

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"

    assert_content "33%"

    skip_checkbox = find("input[type='checkbox'][name='skipped']")
    skip_checkbox.check

    assert_content "Season 1 marked as skipped"

    assert_no_content "33%"
  end

  test "unmarking season as skipped enables episode checkboxes" do
    MySeason.create!(human: @human, season: @season, skipped: true)

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    check "Show skipped seasons"
    click_on "Season 1"

    episode_checkbox = first("input[type='checkbox'][name='watched']")

    assert_predicate episode_checkbox, :disabled?

    skip_checkbox = find("input[type='checkbox'][name='skipped']")

    assert_predicate skip_checkbox, :checked?

    skip_checkbox.uncheck

    assert_content "Season 1 unmarked as skipped"

    episode_checkbox = first("input[type='checkbox'][name='watched']")

    assert_not_predicate episode_checkbox, :disabled?
  end

  test "unmarking season as skipped shows progress bar" do
    MySeason.create!(human: @human, season: @season, skipped: true, watched_episode_numbers: [1])

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    check "Show skipped seasons"
    click_on "Season 1"

    assert_no_content "33%"

    skip_checkbox = find("input[type='checkbox'][name='skipped']")
    skip_checkbox.uncheck

    assert_content "Season 1 unmarked as skipped"

    assert_content "33%"
  end

  test "skipped season does not show available episodes badge on seasons list" do
    season2 = Season.create!(
      show: @show,
      name: "Season 2",
      season_number: 2,
      episode_count: 2,
      tmdb_id: 62_140,
      slug: "season-2"
    )

    Episode.create!(
      season: season2,
      name: "SETI",
      episode_number: 1,
      tmdb_id: 976_458,
      air_date: 1.day.ago
    )

    Episode.create!(
      season: season2,
      name: "Giant",
      episode_number: 2,
      tmdb_id: 976_459,
      air_date: 1.day.ago
    )

    MySeason.create!(human: @human, season: season2, skipped: true)

    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug, include_skipped: "1")

    season1_links = all("a[href='/shows/halt-and-catch-fire/season-1']")
    season1_poster_link = season1_links.first

    within(season1_poster_link) do
      assert_selector "div[title*='available episode']"
    end

    season2_links = all("a[href='/shows/halt-and-catch-fire/season-2']")
    season2_poster_link = season2_links.first

    within(season2_poster_link) do
      assert_no_selector "div[title*='available episode']"
    end
  end
end
