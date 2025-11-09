require "application_system_test_case"

# System test for showing/hiding skipped seasons on show page
class ShowingSkippedSeasonsTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "joe",
      email: "joe@example.com",
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

    @season1 = Season.create!(
      show: @show,
      name: "Season 1",
      season_number: 1,
      episode_count: 2,
      tmdb_id: 62_139,
      slug: "season-1"
    )

    @season2 = Season.create!(
      show: @show,
      name: "Season 2",
      season_number: 2,
      episode_count: 2,
      tmdb_id: 62_140,
      slug: "season-2"
    )

    @my_show = MyShow.create!(
      human: @human,
      show: @show,
      status: "currently_watching"
    )

    MySeason.create!(human: @human, season: @season1, skipped: true)
  end

  test "skipped seasons are hidden by default" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"

    assert_content "Season 2"
    assert_no_content "Season 1"
  end

  test "checking 'Show skipped seasons' checkbox shows skipped seasons" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"

    assert_no_content "Season 1"

    check "Show skipped seasons"

    assert_content "Season 1"
    assert_content "Season 2"
  end

  test "unchecking 'Show skipped seasons' checkbox hides skipped seasons" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug, include_skipped: "1")

    assert_content "Season 1"
    assert_content "Season 2"

    uncheck "Show skipped seasons"

    assert_no_content "Season 1"
    assert_content "Season 2"
  end

  test "show skipped seasons checkbox does not appear for visitors" do
    visit show_path(@show.slug)

    assert_no_content "Show skipped seasons"
    assert_content "Season 1"
    assert_content "Season 2"
  end

  test "show skipped seasons checkbox does not appear if user has not added show" do
    other_human = Human.create!(handle: "bosworth", email: "bosworth@example.com")
    other_magic_link = MagicLink.create!(email: other_human.email)

    visit redeem_magic_link_path(other_magic_link.token)
    visit show_path(@show.slug)

    assert_no_content "Show skipped seasons"
    assert_content "Season 1"
    assert_content "Season 2"
  end

  test "show skipped seasons checkbox does not appear when no seasons are skipped" do
    MySeason.where(human: @human, season: @season1).delete_all

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"

    assert_no_content "Show skipped seasons"
    assert_content "Season 1"
    assert_content "Season 2"
  end
end
