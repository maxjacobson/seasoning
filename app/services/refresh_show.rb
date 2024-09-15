RefreshShow = lambda { |show|
  Show.transaction do
    details = TMDB::Client.new.tv_details(show.tmdb_tv_id)

    show.update!(
      tmdb_poster_path: details.poster_path,
      tmdb_next_refresh_at: Show.refresh_interval(details),
      first_air_date: details.first_air_date,
      tmdb_last_refreshed_at: Time.zone.now
    )

    details.seasons.each do |tmdb_season|
      next if tmdb_season.season_number.zero?
      next if tmdb_season.episode_count.zero?
      next if tmdb_season.air_date.nil? # skip not-yet-aired seasons

      season = show.seasons.find_by(season_number: tmdb_season.season_number)
      if season.present?
        season.update!(
          episode_count: tmdb_season.episode_count,
          tmdb_id: tmdb_season.id,
          tmdb_poster_path: tmdb_season.poster_path
        )
      else
        season = show.seasons.create(
          tmdb_id: tmdb_season.id,
          name: tmdb_season.name,
          season_number: tmdb_season.season_number,
          episode_count: tmdb_season.episode_count,
          tmdb_poster_path: tmdb_season.poster_path
        )
      end
      RefreshEpisodes.call(show, season)
    end
  end
}
