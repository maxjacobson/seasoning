# frozen_string_literal: true

# represents a show that someone is trying to add to the site
class ImportSerializer < Oj::Serializer
  attributes :id, :name
  serializer_attributes :poster_url

  def poster_url
    Poster.new(import.poster_path).url
  end
end
