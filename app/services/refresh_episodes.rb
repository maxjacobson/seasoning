# frozen_string_literal: true

RefreshEpisodes = lambda do |show, season|
  data = TMDB::Client.new.season_details(show.tmdb_tv_id, season.season_number)

  data.episodes.each do |tmdb_episode|
    episode = season.episodes.find_or_initialize_by(episode_number: tmdb_episode.episode_number)
    episode.name = tmdb_episode.name
    episode.still_path = tmdb_episode.still_path
    episode.tmdb_id = tmdb_episode.id
    episode.air_date = tmdb_episode.air_date
    episode.save!
  end
end
