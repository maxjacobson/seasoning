# frozen_string_literal: true

# Serializes the episode to JSON
class EpisodeSerializer < Oj::Serializer
  attributes :name, :episode_number, :air_date
  serializer_attributes :still_url, :available

  def available
    episode.available?
  end

  def still_url
    episode.still.url
  end
end
