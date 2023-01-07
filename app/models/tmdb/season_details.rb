# frozen_string_literal: true

module TMDB
  class SeasonDetails < Dry::Struct
    attribute :air_date, Types::String.optional
    attribute :episodes, Types::Array do
      attribute :air_date, Types::String.optional
      attribute :episode_number, Types::Integer
      attribute :id, Types::Integer
      attribute :name, Types::String
      attribute :overview, Types::String
      attribute :runtime, Types::Integer.optional
      attribute :still_path, Types::String.optional
    end
    attribute :id, Types::Integer
    attribute :name, Types::String
    attribute :overview, Types::String
    attribute :poster_path, Types::String.optional
    attribute :season_number, Types::Integer
  end
end
