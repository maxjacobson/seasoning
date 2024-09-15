# Serializes the season to JSON
class SeasonSerializer < Oj::Serializer
  attributes :id, :name, :season_number, :episode_count, :slug
  serializer_attributes :poster_url, :episodes

  def poster_url
    season.poster.url
  end

  def episodes
    EpisodeSerializer.many(season.episodes.order(episode_number: :asc))
  end
end
