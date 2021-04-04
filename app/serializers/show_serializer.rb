# frozen_string_literal: true

# Serializes the show to JSON
class ShowSerializer < Oj::Serializer
  attributes :id, :title, :slug
  serializer_attributes :poster_url

  def poster_url
    show.poster.url
  end
end
