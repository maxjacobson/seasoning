# frozen_string_literal: true

# Serializes the guest to JSON
class ShowSerializer < Oj::Serializer
  attributes :id, :title, :slug, :number_of_seasons
end
