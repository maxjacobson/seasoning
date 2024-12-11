# Serializes the episode to JSON
class EpisodeSerializer < Oj::Serializer
  attributes :name, :episode_number, :air_date
  serializer_attributes :still_url

  def still_url
    episode.still.url
  end
end
