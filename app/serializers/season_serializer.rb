# frozen_string_literal: true

# Serializes the season to JSON
class SeasonSerializer < Oj::Serializer
  attributes :id, :name, :season_number, :episode_count, :slug
  serializer_attributes :poster_url

  def poster_url
    season.poster.url
  end
end
