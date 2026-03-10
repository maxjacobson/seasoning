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

  test "available_unwatched_content? returns true when show has no watched seasons but has released episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    my_show = MyShow.create!(human: human, show: show, status: "waiting")

    assert_predicate my_show, :available_unwatched_content?
  end

  test "available_unwatched_content? returns true when watched seasons exist but newer ones are available" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 1)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 1")

    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1])

    assert_predicate my_show, :available_unwatched_content?
  end

  test "available_unwatched_content? returns false when all available seasons are watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1])

    assert_not my_show.available_unwatched_content?
  end

  test "available_unwatched_content? returns false when show has no released episodes yet" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 789, name: "Episode 1")
    my_show = MyShow.create!(human: human, show: show, status: "waiting")

    assert_not my_show.available_unwatched_content?
  end

  test "available_unwatched_content? returns false when show has no seasons" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting")

    assert_not my_show.available_unwatched_content?
  end

  test "available_unwatched_content? returns false when only new season is skipped" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 1)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 1")

    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1])
    MySeason.create!(human: human, season: season2, skipped: true)

    assert_not my_show.available_unwatched_content?
  end

  test "available_unwatched_content? returns true when new season exists beyond skipped season" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 1)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 1")

    season3 = Season.create!(show: show, season_number: 3, name: "Season 3", tmdb_id: 458, episode_count: 1)
    Episode.create!(season: season3, episode_number: 1, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 1")

    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1])
    MySeason.create!(human: human, season: season2, skipped: true)

    assert_predicate my_show, :available_unwatched_content?
  end

  test "available_unwatched_content? returns true when new episode added to middle season" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 2)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 1.day.ago, tmdb_id: 792, name: "Bonus Episode")

    season3 = Season.create!(show: show, season_number: 3, name: "Season 3", tmdb_id: 458, episode_count: 1)
    Episode.create!(season: season3, episode_number: 1, air_date: 1.day.ago, tmdb_id: 793, name: "Episode 1")

    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1, 2])
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1])
    MySeason.create!(human: human, season: season3, watched_episode_numbers: [1])

    assert_predicate my_show, :available_unwatched_content?
  end

  test "available_unwatched_content? returns true for old unwatched season unless skipped" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 1)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 1")

    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1])

    assert_predicate my_show, :available_unwatched_content?
  end

  test "unwatched_episode_badge returns 0 available and 0 upcoming when no episodes exist" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")

    badge = my_show.unwatched_episode_badge

    assert_equal 0, badge.available
    assert_equal 0, badge.upcoming
  end

  test "unwatched_episode_badge returns 0 available and counts upcoming when all episodes are future" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 2.days.from_now, tmdb_id: 790, name: "Episode 2")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")

    badge = my_show.unwatched_episode_badge

    assert_equal 0, badge.available
    assert_equal 2, badge.upcoming
  end

  test "unwatched_episode_badge returns 0 when all available episodes are watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    badge = my_show.unwatched_episode_badge

    assert_equal 0, badge.available
  end

  test "unwatched_episode_badge returns correct count of available unwatched episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season, episode_number: 1, air_date: 2.days.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    badge = my_show.unwatched_episode_badge

    assert_equal 2, badge.available
  end

  test "unwatched_episode_badge counts future episodes as upcoming" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.from_now, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 2.days.from_now, tmdb_id: 792, name: "Episode 4")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")

    badge = my_show.unwatched_episode_badge

    assert_equal 2, badge.available
    assert_equal 2, badge.upcoming
  end

  test "unwatched_episode_badge works across multiple seasons" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 3)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 2")
    Episode.create!(season: season2, episode_number: 3, air_date: 1.day.ago, tmdb_id: 793, name: "Episode 3")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1, 2])
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1])

    badge = my_show.unwatched_episode_badge

    assert_equal 2, badge.available
  end

  test "unwatched_episode_badge handles season with no MySeason record" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")

    badge = my_show.unwatched_episode_badge

    assert_equal 3, badge.available
  end

  test "unwatched_episode_badge excludes episodes with no air_date" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: nil, tmdb_id: 790, name: "Episode 2")
    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")

    badge = my_show.unwatched_episode_badge

    assert_equal 1, badge.available
  end

  test "unwatched_episode_badge excludes episodes from skipped seasons" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 3)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 2")
    Episode.create!(season: season2, episode_number: 3, air_date: 1.day.ago, tmdb_id: 793, name: "Episode 3")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, skipped: true)

    badge = my_show.unwatched_episode_badge

    assert_equal 3, badge.available
    assert_equal 0, badge.upcoming
  end

  test "unwatched_episode_badge excludes upcoming episodes from skipped seasons" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 2.days.from_now, tmdb_id: 790, name: "Episode 2")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 2)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 791, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 2.days.from_now, tmdb_id: 792, name: "Episode 2")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, skipped: true)

    badge = my_show.unwatched_episode_badge

    assert_equal 0, badge.available
    assert_equal 2, badge.upcoming
  end

  test "watched_percentage excludes skipped seasons from total episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season1, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season1, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 2)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 793, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 1.day.ago, tmdb_id: 794, name: "Episode 2")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, skipped: true)
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1])

    assert_in_delta(50.0, my_show.watched_percentage)
  end

  test "watched_percentage excludes watched episodes from skipped seasons" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 2)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 2")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, skipped: true, watched_episode_numbers: [1, 2])
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1])

    assert_in_delta(50.0, my_show.watched_percentage)
  end

  test "watched_percentage returns 100 when all non-skipped episodes are watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 5)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season1, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season1, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")
    Episode.create!(season: season1, episode_number: 5, air_date: 1.day.ago, tmdb_id: 793, name: "Episode 5")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 2)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 794, name: "Episode 1")
    Episode.create!(season: season2, episode_number: 2, air_date: 1.day.ago, tmdb_id: 795, name: "Episode 2")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, skipped: true)
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1, 2])

    assert_in_delta(100.0, my_show.watched_percentage)
  end

  test "watched_episodes? returns false when human has no my_seasons for the show" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting")

    assert_not my_show.watched_episodes?
  end

  test "watched_episodes? returns false when human has a my_season with no watched episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [])

    assert_not my_show.watched_episodes?
  end

  test "watched_episodes? returns true when human has watched at least one episode" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    my_show = MyShow.create!(human: human, show: show, status: "waiting")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1])

    assert_predicate my_show, :watched_episodes?
  end

  test "watched_episodes? only considers episodes for the relevant show" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show1 = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    show2 = Show.create!(title: "Some Other Show", tmdb_tv_id: 124)
    season2 = Season.create!(show: show2, season_number: 1, name: "Season 1", tmdb_id: 457, episode_count: 1)
    my_show1 = MyShow.create!(human: human, show: show1, status: "waiting")
    MySeason.create!(human: human, season: season2, watched_episode_numbers: [1])

    assert_not my_show1.watched_episodes?
  end

  test "watched_percentage returns 0 when only skipped seasons exist" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season1, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season1, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")

    my_show = MyShow.create!(human: human, show: show, status: "currently_watching")
    MySeason.create!(human: human, season: season1, skipped: true, watched_episode_numbers: [1, 2])

    assert_in_delta(0.0, my_show.watched_percentage)
  end

  test "snoozed? returns true when snoozed_until is set" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: 1.week.from_now)

    assert_predicate my_show, :snoozed?
  end

  test "snoozed? returns true when snoozed_until is in the past" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: 1.day.ago)

    assert_predicate my_show, :snoozed?
  end

  test "snoozed? returns false when snoozed_until is nil" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting")

    assert_not_predicate my_show, :snoozed?
  end

  test "still_snoozing? returns true when snoozed_until is in the future" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: 1.week.from_now)

    assert_predicate my_show, :still_snoozing?
  end

  test "still_snoozing? returns false when snoozed_until is in the past" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: 1.day.ago)

    assert_not_predicate my_show, :still_snoozing?
  end

  test "still_snoozing? returns false when snoozed_until is nil" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting")

    assert_not_predicate my_show, :still_snoozing?
  end

  test "snooze_days_remaining returns ceiling of days left" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: 6.5.days.from_now)

    assert_equal 7, my_show.snooze_days_remaining
  end

  test "snooze_days_remaining returns 0 when snooze has expired" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: 1.day.ago)

    assert_equal 0, my_show.snooze_days_remaining
  end

  test "clears snoozed_until when status changes away from waiting" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: 1.week.from_now)

    my_show.update!(status: "currently_watching")

    assert_nil my_show.reload.snoozed_until
  end

  test "does not clear snoozed_until when status stays at waiting" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    snoozed_until = 1.week.from_now
    my_show = MyShow.create!(human: human, show: show, status: "waiting", snoozed_until: snoozed_until)

    my_show.update!(note_to_self: "cool show")

    assert_not_nil my_show.reload.snoozed_until
  end
end
