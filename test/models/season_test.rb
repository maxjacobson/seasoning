require "test_helper"

# unit tests for Season model
class SeasonTest < ActiveSupport::TestCase
  test "#available_episodes_count_for returns 0 when no episodes exist" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 0)

    assert_equal 0, season.available_episodes_count_for(human)
  end

  test "#available_episodes_count_for returns 0 when no episodes are available (all future)" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 2.days.from_now, tmdb_id: 790, name: "Episode 2")

    assert_equal 0, season.available_episodes_count_for(human)
  end

  test "#available_episodes_count_for returns 0 when all available episodes are watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    assert_equal 0, season.available_episodes_count_for(human)
  end

  test "#available_episodes_count_for returns correct count of available unwatched episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season, episode_number: 1, air_date: 2.days.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    assert_equal 2, season.available_episodes_count_for(human)
  end

  test "#available_episodes_count_for ignores future episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.from_now, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 2.days.from_now, tmdb_id: 792, name: "Episode 4")

    assert_equal 2, season.available_episodes_count_for(human)
  end

  test "#available_episodes_count_for returns all available when no MySeason record exists" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")

    assert_equal 3, season.available_episodes_count_for(human)
  end

  test "#available_episodes_count_for excludes episodes with no air_date" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: nil, tmdb_id: 790, name: "Episode 2")

    assert_equal 1, season.available_episodes_count_for(human)
  end

  test "#available_episodes_count_for correctly counts partial watched episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 5)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")
    Episode.create!(season: season, episode_number: 5, air_date: 1.day.ago, tmdb_id: 793, name: "Episode 5")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 3, 5])

    assert_equal 2, season.available_episodes_count_for(human)
  end
end
