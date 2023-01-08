# frozen_string_literal: true

# Serializes the episode to JSON
class EpisodeSerializer < Oj::Serializer
  attributes :name, :episode_number
  serializer_attributes :still_url

  def still_url
    episode.still.url
  end
end
