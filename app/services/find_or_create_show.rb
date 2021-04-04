# frozen_string_literal: true

FindOrCreateShow = lambda { |tmdb_show|
  show = Show.find_by(title: tmdb_show.name)
  show ||= Show.create!(
    title: tmdb_show.name,
    tmdb_tv_id: tmdb_show.id,
    tmdb_poster_path: tmdb_show.poster_path,
    tmdb_next_refresh_at: Show::REFRESH_INTERVAL.from_now
  )

  TMDB::Client.new.tv_details(show.tmdb_tv_id).seasons.each do |tmdb_season|
    next if show.seasons.exists?(season_number: tmdb_season.season_number)
    next if tmdb_season.season_number.zero?

    show.seasons.create(
      tmdb_id: tmdb_season.id,
      name: tmdb_season.name,
      season_number: tmdb_season.season_number,
      episode_count: tmdb_season.episode_count
    )
  end

  show
}
