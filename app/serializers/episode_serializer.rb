# frozen_string_literal: true

# Serializes the episode to JSON
class EpisodeSerializer < Oj::Serializer
  attributes :name, :episode_number, :still_path
end
