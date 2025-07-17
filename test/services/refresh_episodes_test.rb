require "test_helper"

class RefreshEpisodesTest < ActiveSupport::TestCase
  test ".call when the episodes have not yet been imported imports the episodes" do
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

    RefreshEpisodes.call(show, season)

    assert_request_requested request
    assert_equal 3, season.episodes.count

    episode = season.episodes.find_by!(episode_number: 2)

    assert_equal "The Nighthawks", episode.name
    assert_equal 4_149_045, episode.tmdb_id
  end

  test ".call when the episodes have 100% already been imported does nothing" do
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

    RefreshEpisodes.call(show, season)

    assert_request_requested request
    assert_equal 3, season.episodes.count

    episode = season.episodes.find_by!(episode_number: 2)

    assert_equal "The Nighthawks", episode.name
    assert_equal 4_149_045, episode.tmdb_id
  end

  test ".call when there are some new episodes to import imports the new episodes and doesn't touch the old ones" do
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

    RefreshEpisodes.call(show, season)

    assert_request_requested request
    assert_equal 3, season.episodes.count
    episode = season.episodes.find_by!(episode_number: 3)

    assert_equal "Just Tuesday", episode.name
    assert_equal 4_044_637, episode.tmdb_id
  end

  test ".call when the episodes have been rearranged updates the arrangement of the existing episodes" do
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

    RefreshEpisodes.call(show, season)

    assert_request_requested request
    assert_equal 3, season.episodes.count

    episode = season.episodes.find_by!(episode_number: 2)

    assert_equal "The Nighthawks", episode.name
    assert_equal 4_149_045, episode.tmdb_id
  end
end
