require "test_helper"

# unit tests for Season model
class SeasonTest < ActiveSupport::TestCase
  test "#unwatched_episode_badge_for returns 0 when no episodes exist" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 0)

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 0, badge.available
    assert_equal 0, badge.upcoming
  end

  test "#unwatched_episode_badge_for returns 0 available and counts upcoming when all future" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 2.days.from_now, tmdb_id: 790, name: "Episode 2")

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 0, badge.available
    assert_equal 2, badge.upcoming
  end

  test "#unwatched_episode_badge_for returns 0 when all available episodes are watched" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 0, badge.available
  end

  test "#unwatched_episode_badge_for returns correct count of available unwatched episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season, episode_number: 1, air_date: 2.days.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 2])

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 2, badge.available
  end

  test "#unwatched_episode_badge_for counts future episodes as upcoming" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 4)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.from_now, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 2.days.from_now, tmdb_id: 792, name: "Episode 4")

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 2, badge.available
    assert_equal 2, badge.upcoming
  end

  test "#unwatched_episode_badge_for returns all available when no MySeason record exists" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 3, badge.available
  end

  test "#unwatched_episode_badge_for excludes episodes with no air_date" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: nil, tmdb_id: 790, name: "Episode 2")

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 1, badge.available
  end

  test "#unwatched_episode_badge_for correctly counts partial watched episodes" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 5)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    Episode.create!(season: season, episode_number: 4, air_date: 1.day.ago, tmdb_id: 792, name: "Episode 4")
    Episode.create!(season: season, episode_number: 5, air_date: 1.day.ago, tmdb_id: 793, name: "Episode 5")
    MySeason.create!(human: human, season: season, watched_episode_numbers: [1, 3, 5])

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 2, badge.available
  end

  test "#unwatched_episode_badge_for returns 0 for skipped season" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    MySeason.create!(human: human, season: season, skipped: true)

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 0, badge.available
    assert_equal 0, badge.upcoming
  end

  test "#unwatched_episode_badge_for returns 0 upcoming for skipped season" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 2)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.from_now, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 2.days.from_now, tmdb_id: 790, name: "Episode 2")
    MySeason.create!(human: human, season: season, skipped: true)

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 0, badge.available
    assert_equal 0, badge.upcoming
  end

  test "#unwatched_episode_badge_for ignores watched episodes when season is skipped" do
    human = Human.create!(handle: "donna_clark", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 3)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")
    Episode.create!(season: season, episode_number: 2, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 2")
    Episode.create!(season: season, episode_number: 3, air_date: 1.day.ago, tmdb_id: 791, name: "Episode 3")
    MySeason.create!(human: human, season: season, skipped: true, watched_episode_numbers: [1, 2])

    badge = season.unwatched_episode_badge_for(human)

    assert_equal 0, badge.available
    assert_equal 0, badge.upcoming
  end

  test "#refresh_episodes! when the episodes have not yet been imported imports the episodes" do
    request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
              .to_return(
                status: 200,
                body: Rails.root.join("test/webmock/tmdb/night-court-season-1.json").read
              )

    show = Show.create!(
      title: "Night Court",
      tmdb_tv_id: 202_101,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season = show.seasons.create!(
      tmdb_id: 293_954,
      name: "Season 1",
      season_number: 1,
      episode_count: 3,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season.refresh_episodes!

    assert_request_requested request
    assert_equal 3, season.episodes.count

    episode = season.episodes.find_by!(episode_number: 2)

    assert_equal "The Nighthawks", episode.name
    assert_equal 4_149_045, episode.tmdb_id
  end

  test "#refresh_episodes! when the episodes have 100% already been imported does nothing" do
    request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
              .to_return(
                status: 200,
                body: Rails.root.join("test/webmock/tmdb/night-court-season-1.json").read
              )

    show = Show.create!(
      title: "Night Court",
      tmdb_tv_id: 202_101,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season = show.seasons.create!(
      tmdb_id: 293_954,
      name: "Season 1",
      season_number: 1,
      episode_count: 9,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season.episodes.create!(
      name: "Pilot",
      tmdb_id: 3_724_869,
      episode_number: 1
    )

    season.episodes.create!(
      name: "The Nighthawks",
      tmdb_id: 4_149_045,
      episode_number: 2
    )

    season.episodes.create!(
      name: "Just Tuesday",
      tmdb_id: 4_044_637,
      episode_number: 3
    )

    season.refresh_episodes!

    assert_request_requested request
    assert_equal 3, season.episodes.count

    episode = season.episodes.find_by!(episode_number: 2)

    assert_equal "The Nighthawks", episode.name
    assert_equal 4_149_045, episode.tmdb_id
  end

  test "#refresh_episodes! when there are some new episodes to import imports the new episodes and doesn't touch the old ones" do
    request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
              .to_return(
                status: 200,
                body: Rails.root.join("test/webmock/tmdb/night-court-season-1.json").read
              )

    show = Show.create!(
      title: "Night Court",
      tmdb_tv_id: 202_101,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season = show.seasons.create!(
      tmdb_id: 293_954,
      name: "Season 1",
      season_number: 1,
      episode_count: 9,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season.episodes.create!(
      name: "Pilot",
      tmdb_id: 3_724_869,
      episode_number: 1
    )

    season.episodes.create!(
      name: "The Nighthawks",
      tmdb_id: 4_149_045,
      episode_number: 2
    )

    season.refresh_episodes!

    assert_request_requested request
    assert_equal 3, season.episodes.count
    episode = season.episodes.find_by!(episode_number: 3)

    assert_equal "Just Tuesday", episode.name
    assert_equal 4_044_637, episode.tmdb_id
  end

  test "#refresh_episodes! when the episodes have been rearranged updates the arrangement of the existing episodes" do
    request = stub_request(:get, "https://api.themoviedb.org/3/tv/202101/season/1?api_key=xxxx")
              .to_return(
                status: 200,
                body: Rails.root.join("test/webmock/tmdb/night-court-season-1.json").read
              )

    show = Show.create!(
      title: "Night Court",
      tmdb_tv_id: 202_101,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season = show.seasons.create!(
      tmdb_id: 293_954,
      name: "Season 1",
      season_number: 1,
      episode_count: 9,
      tmdb_poster_path: "/ctTaOOAg9iZtvVBOyH2UE5ifBHg.jpg"
    )

    season.episodes.create!(
      name: "Pilot",
      tmdb_id: 3_724_869,
      episode_number: 1
    )

    season.episodes.create!(
      name: "Just Tuesday",
      tmdb_id: 4_044_637,
      episode_number: 2
    )

    season.episodes.create!(
      name: "The Nighthawks",
      tmdb_id: 4_149_045,
      episode_number: 3
    )

    season.refresh_episodes!

    assert_request_requested request
    assert_equal 3, season.episodes.count

    episode = season.episodes.find_by!(episode_number: 2)

    assert_equal "The Nighthawks", episode.name
    assert_equal 4_149_045, episode.tmdb_id
  end
end
