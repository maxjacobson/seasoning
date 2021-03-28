# frozen_string_literal: true

# Serializes the show to JSON
class ShowSerializer < Oj::Serializer
  attributes :id, :title, :slug
end
