require "test_helper"

class ShowDetailsPageTest < ActiveSupport::TestCase
  test "exposes the show" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_equal show, page.show
  end

  test "returns nil for my_show when no current_human" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_nil page.my_show
  end

  test "returns my_show when current_human has saved the show" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    my_show = MyShow.create!(human: donna, show: show)

    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_equal my_show, page.my_show
  end

  test "returns nil for my_show when current_human hasn't saved the show" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)

    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_nil page.my_show
  end

  test "skipped_seasons? returns false when no current_human" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_not page.skipped_seasons?
  end

  test "skipped_seasons? returns false when current_human has no skipped seasons" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)

    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_not page.skipped_seasons?
  end

  test "skipped_seasons? returns true when current_human has skipped seasons" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    season = Season.create!(show: show, name: "Season 1", season_number: 1, slug: "season-1", tmdb_id: 54_321,
                            episode_count: 10)
    MySeason.create!(human: donna, season: season, skipped: true)

    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_predicate page, :skipped_seasons?
  end

  test "seasons returns all seasons in order when include_skipped is true" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    season = Season.create!(show: show, name: "Season 1", season_number: 1, slug: "season-1", tmdb_id: 54_321,
                            episode_count: 10)
    MySeason.create!(human: donna, season: season, skipped: true)

    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: true)

    assert_equal show.seasons.order(season_number: :asc).to_a, page.seasons
  end

  test "seasons returns all seasons when no current_human" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    Season.create!(show: show, name: "Season 1", season_number: 1, slug: "season-1", tmdb_id: 54_321, episode_count: 10)

    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_equal show.seasons.order(season_number: :asc).to_a, page.seasons
  end

  test "seasons returns all seasons when current_human has no my_show" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    Season.create!(show: show, name: "Season 1", season_number: 1, slug: "season-1", tmdb_id: 54_321, episode_count: 10)

    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_equal show.seasons.order(season_number: :asc).to_a, page.seasons
  end

  test "seasons excludes skipped seasons when include_skipped is false and current_human has my_show" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    MyShow.create!(human: donna, show: show)
    season1 = Season.create!(show: show, name: "Season 1", season_number: 1, slug: "season-1", tmdb_id: 54_321,
                             episode_count: 10)
    season2 = Season.create!(show: show, name: "Season 2", season_number: 2, slug: "season-2", tmdb_id: 54_322,
                             episode_count: 10)
    MySeason.create!(human: donna, season: season1, skipped: true)

    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_equal [season2], page.seasons
  end

  test "added? returns false when no current_human" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_not page.added?
  end

  test "added? returns false when current_human hasn't saved the show" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_not page.added?
  end

  test "added? returns true when current_human has saved the show" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    MyShow.create!(human: donna, show: show)
    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_predicate page, :added?
  end

  test "watched_percentage returns 0 when not added" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_equal 0, page.watched_percentage
  end

  test "watched_percentage returns my_show watched_percentage when added" do
    donna = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    my_show = MyShow.create!(human: donna, show: show)
    page = ShowDetailsPage.new(show: show, current_human: donna, include_skipped: false)

    assert_equal my_show.watched_percentage, page.watched_percentage
  end

  test "title delegates to show" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_equal "Halt and Catch Fire", page.title
  end

  test "slug delegates to show" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_equal "halt-and-catch-fire", page.slug
  end

  test "tmdb_url returns the TMDB URL for the show" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_equal "https://www.themoviedb.org/tv/12345", page.tmdb_url
  end

  test "seasons? returns true when show has seasons" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    Season.create!(show: show, name: "Season 1", season_number: 1, slug: "season-1", tmdb_id: 54_321, episode_count: 10)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_predicate page, :seasons?
  end

  test "seasons? returns false when show has no seasons" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    page = ShowDetailsPage.new(show: show, current_human: nil, include_skipped: false)

    assert_not page.seasons?
  end
end
