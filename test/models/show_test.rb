require "test_helper"

class ShowTest < ActiveSupport::TestCase
  test "#watchers_count returns count of humans who have added the show" do
    show = Show.create!(
      title: "Test Show",
      slug: "test-show",
      tmdb_tv_id: 12_345
    )

    # Initially no watchers
    assert_equal 0, show.watchers_count

    # Add some humans who watch the show
    human1 = Human.create!(handle: "donna", email: "donna@example.com")
    human2 = Human.create!(handle: "cameron", email: "cameron@example.com")

    MyShow.create!(human: human1, show: show, status: "currently_watching")
    MyShow.create!(human: human2, show: show, status: "finished")

    # Should count both watchers
    assert_equal 2, show.watchers_count
  end

  test "#skipped_seasons_for? returns true when human has skipped seasons" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    MySeason.create!(human: human, season: season, skipped: true)

    assert show.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? returns false when human has no skipped seasons" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    MySeason.create!(human: human, season: season, skipped: false)

    assert_not show.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? returns false when human has no my_seasons for this show" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    assert_not show.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? only checks seasons for this show" do
    show1 = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    show2 = Show.create!(title: "Other Show", tmdb_tv_id: 456)
    Season.create!(show: show1, season_number: 1, name: "Season 1", tmdb_id: 789, episode_count: 1)
    season2 = Season.create!(show: show2, season_number: 1, name: "Season 1", tmdb_id: 890, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    MySeason.create!(human: human, season: season2, skipped: true)

    assert_not show1.skipped_seasons_for?(human)
    assert show2.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? returns false when human is nil" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    assert_not show.skipped_seasons_for?(nil)
  end
end
