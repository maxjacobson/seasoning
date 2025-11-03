require "test_helper"

class CheckForNewSeasonsTest < ActiveSupport::TestCase
  test "returns true and updates status when new seasons available for show with watched episodes" do
    human = Human.create!(handle: "donna", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 123)

    season1 = show.seasons.create!(season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")

    season2 = show.seasons.create!(season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 1)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 1")

    my_show = MyShow.create!(human:, show:, status: "waiting_for_more")
    MySeason.create!(human:, season: season1, watched_episode_numbers: [1, 2])

    result = CheckForNewSeasons.call(my_show)

    assert result
    assert_predicate my_show.reload, :next_up?
    assert ReturningShowNotification.exists?(human:, show:)
  end

  test "returns true and updates status when new seasons available for unwatched show" do
    human = Human.create!(handle: "donna", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 123)

    season1 = show.seasons.create!(season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    my_show = MyShow.create!(human:, show:, status: "waiting_for_more")

    result = CheckForNewSeasons.call(my_show)

    assert result
    assert_predicate my_show.reload, :next_up?
    assert ReturningShowNotification.exists?(human:, show:)
  end

  test "returns false and does not update status when no new seasons available" do
    human = Human.create!(handle: "donna", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 123)

    season1 = show.seasons.create!(season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")

    my_show = MyShow.create!(human:, show:, status: "waiting_for_more")
    MySeason.create!(human:, season: season1, watched_episode_numbers: [1, 2])

    result = CheckForNewSeasons.call(my_show)

    assert_not result
    assert_predicate my_show.reload, :waiting_for_more?
    assert_not ReturningShowNotification.exists?(human:, show:)
  end

  test "creates a notification when new seasons are available" do
    human = Human.create!(handle: "donna", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 123)

    season1 = show.seasons.create!(season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    my_show = MyShow.create!(human:, show:, status: "waiting_for_more")

    assert_difference -> { ReturningShowNotification.count } do
      CheckForNewSeasons.call(my_show)
    end

    assert ReturningShowNotification.exists?(human:, show:)
  end
end
