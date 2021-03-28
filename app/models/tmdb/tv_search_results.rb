# frozen_string_literal: true

module TMDB
  class TVSearchResults < Dry::Struct
    attribute :page, Types::Integer
    attribute :total_pages, Types::Integer
    attribute :total_results, Types::Integer

    attribute :results, Types::Array do
      attribute :id, Types::Integer
      attribute :name, Types::String
      attribute :first_air_date, Types::String
    end
  end
end
