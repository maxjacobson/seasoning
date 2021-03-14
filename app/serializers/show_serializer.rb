# frozen_string_literal: true

# Serializes the show to JSON
class ShowSerializer < Oj::Serializer
  attributes :id, :title, :slug, :number_of_seasons
end
