RefreshShow = lambda { |show|
  begin
    details = TMDB::Client.new.tv_details(show.tmdb_tv_id)
  rescue TMDB::Client::NotFound
    show.update!(orphaned: true)
    next
  end

  Show.transaction do
    show.update!(
      tmdb_poster_path: details.poster_path,
      tmdb_next_refresh_at: Show.refresh_interval(details),
      first_air_date: details.first_air_date,
      tmdb_last_refreshed_at: Time.zone.now,
      orphaned: false
    )

    seen_season_ids = []

    details.seasons.each do |tmdb_season|
      next if tmdb_season.season_number.zero?
      next if tmdb_season.episode_count.zero?
      next if tmdb_season.air_date.nil? # skip not-yet-aired seasons

      season = show.seasons.find_by(season_number: tmdb_season.season_number)
      if season.present?
        season.update!(
          name: tmdb_season.name,
          episode_count: tmdb_season.episode_count,
          tmdb_id: tmdb_season.id,
          tmdb_poster_path: tmdb_season.poster_path,
          air_date: tmdb_season.air_date,
          orphaned: false
        )
      else
        season = show.seasons.create!(
          tmdb_id: tmdb_season.id,
          name: tmdb_season.name,
          season_number: tmdb_season.season_number,
          episode_count: tmdb_season.episode_count,
          tmdb_poster_path: tmdb_season.poster_path,
          air_date: tmdb_season.air_date
        )
      end
      seen_season_ids << season.id
      RefreshEpisodes.call(show, season)
    end

    show.seasons.where.not(id: seen_season_ids).find_each do |season|
      season.update!(orphaned: true)
    end
  end
}
