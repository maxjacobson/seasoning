RefreshEpisodes = lambda do |show, season|
  Rails.logger.info "Refreshing show slug=#{show.slug} season slug=#{season.slug}"

  data = TMDB::Client.new.season_details(show.tmdb_tv_id, season.season_number)

  season.episodes.destroy_all
  data.episodes.each do |tmdb_episode|
    Rails.logger.info(
      <<~MSG.squish
        Inserting episode show slug=#{show.slug}
        season slug=#{season.slug}
        episode number=#{tmdb_episode.episode_number}
        tmdb_id=#{tmdb_episode.id}
      MSG
    )
    episode = season.episodes.new(episode_number: tmdb_episode.episode_number)
    episode.name = tmdb_episode.name
    episode.still_path = tmdb_episode.still_path
    episode.tmdb_id = tmdb_episode.id
    episode.air_date = tmdb_episode.air_date
    episode.save!
  end
end
