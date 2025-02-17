require "test_helper"

# unit tests for Episode model
class EpisodeTest < ActiveSupport::TestCase
  setup do
    @show = Show.create!(title: "Not Dead Yet", tmdb_tv_id: 42)
    @season = Season.create!(show: @show, tmdb_id: 42, name: "Season 1", season_number: 1, episode_count: 1)
  end

  test "#available? when air_date is today" do
    episode = Episode.create!(season: @season, air_date: Time.zone.today, name: "Pilot", tmdb_id: 42, episode_number: 1)

    assert_predicate episode, :available?
  end

  test "#available? when air_date is in the past" do
    episode = Episode.create!(season: @season, air_date: 4.days.ago, name: "Pilot", tmdb_id: 42, episode_number: 1)

    assert_predicate episode, :available?
  end

  test "#available? when air_date is in the future" do
    episode = Episode.create!(
      season: @season,
      air_date: 3.days.from_now.to_date,
      name: "Pilot",
      tmdb_id: 42,
      episode_number: 1
    )

    assert_not episode.available?
  end

  test "#available? when air_date is not set" do
    episode = Episode.create!(
      season: @season,
      air_date: nil,
      name: "Pilot",
      tmdb_id: 42,
      episode_number: 1
    )

    assert_not episode.available?
  end
end
