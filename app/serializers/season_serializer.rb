# frozen_string_literal: true

# Serializes the season to JSON
class SeasonSerializer < Oj::Serializer
  attributes :id, :name, :season_number, :episode_count, :slug
end
