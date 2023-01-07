# frozen_string_literal: true

RefreshEpisodes = lambda do |_show, _season|
  Rails.logger.info "Skipping episodes..."

  # data = TMDB::Client.new.season_details(show.tmdb_tv_id, season.season_number)
  # data.episodes.each do |tmdb_episode|
  #   episode = season.episodes.find_or_initialize_by(tmdb_id: tmdb_episode.id)
  #   episode.name = tmdb_episode.name
  #   episode.still_path = tmdb_episode.still_path
  #   episode.episode_number = tmdb_episode.episode_number
  #   episode.save!
  # end
end
