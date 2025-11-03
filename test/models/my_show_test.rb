require "test_helper"

# unit tests for MyShow model
class MyShowTest < ActiveSupport::TestCase
  test "watched_percentage returns 0 when no episodes exist" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")

    assert_in_delta(0.0, my_show.watched_percentage)
  end

  test "watched_percentage returns 0 when no episodes watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")

    assert_in_delta(0.0, my_show.watched_percentage)
  end

  test "watched_percentage returns 100 when all episodes watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    assert_in_delta(100.0, my_show.watched_percentage)
  end

  test "watched_percentage returns correct percentage for partial viewing" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    assert_in_delta(50.0, my_show.watched_percentage)
  end

  test "watched_percentage includes future episodes in total" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.from_now, tmdb_id: 791, name: "Episode 3")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    assert_in_delta(66.7, my_show.watched_percentage)
  end

  test "watched_percentage works across multiple seasons" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 2)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 2")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1, 2])
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1])

    assert_in_delta(75.0, my_show.watched_percentage)
  end

  test "watched_percentage returns 100 when all episodes watched including unaired" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.from_now, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 2.days.from_now, tmdb_id: 791, name: "Episode 3")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2, 3])

    assert_in_delta(100.0, my_show.watched_percentage)
  end

  test "any_new_unwatched_seasons? returns true when show has no watched seasons but has released episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")

    assert_predicate my_show, :any_new_unwatched_seasons?
  end

  test "any_new_unwatched_seasons? returns true when watched seasons exist but newer ones are available" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 1)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 1")

    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")
    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1])

    assert_predicate my_show, :any_new_unwatched_seasons?
  end

  test "any_new_unwatched_seasons? returns false when all available seasons are watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1])

    assert_not my_show.any_new_unwatched_seasons?
  end

  test "any_new_unwatched_seasons? returns false when show has no released episodes yet" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 789, name: "Episode 1")
    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")

    assert_not my_show.any_new_unwatched_seasons?
  end

  test "any_new_unwatched_seasons? returns false when show has no seasons" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")

    assert_not my_show.any_new_unwatched_seasons?
  end
end
