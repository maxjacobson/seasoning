# frozen_string_literal: true

RefreshShow = lambda { |show|
  Show.transaction do
    details = TMDB::Client.new.tv_details(show.tmdb_tv_id)

    show.update!(
      tmdb_poster_path: details.poster_path,
      tmdb_next_refresh_at: Show::REFRESH_INTERVAL.from_now
    )

    details.seasons.each do |tmdb_season|
      next if tmdb_season.season_number.zero?
      next if tmdb_season.episode_count.zero?

      if (season = show.seasons.find_by(season_number: tmdb_season.season_number))
        season.update!(
          episode_count: tmdb_season.episode_count,
          tmdb_poster_path: tmdb_season.poster_path
        )
      else
        show.seasons.create(
          tmdb_id: tmdb_season.id,
          name: tmdb_season.name,
          season_number: tmdb_season.season_number,
          episode_count: tmdb_season.episode_count,
          tmdb_poster_path: tmdb_season.poster_path
        )
      end
    end
  end
}
