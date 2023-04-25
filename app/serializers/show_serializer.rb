# frozen_string_literal: true

# Serializes the show to JSON
class ShowSerializer < Oj::Serializer
  attributes :id, :title, :slug, :tmdb_tv_id, :first_air_date, :tmdb_last_refreshed_at, :tmdb_next_refresh_at
  serializer_attributes :poster_url, :seasons

  def poster_url
    show.poster.url
  end

  def seasons
    SeasonSerializer.many(show.seasons.order(season_number: :asc))
  end
end
