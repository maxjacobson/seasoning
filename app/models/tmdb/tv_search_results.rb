# frozen_string_literal: true

module TMDB
  # https://developers.themoviedb.org/3/search/search-tv-shows
  class TVSearchResults < Dry::Struct
    attribute :page, Types::Integer
    attribute :total_pages, Types::Integer
    attribute :total_results, Types::Integer

    attribute :results, Types::Array do
      attribute :id, Types::Integer
      attribute :name, Types::String
      attribute :poster_path, Types::String.optional
      attribute? :first_air_date, Types::String.optional
    end
  end
end
