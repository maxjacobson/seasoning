# frozen_string_literal: true

module TMDB
  class TVDetails < Dry::Struct
    attribute :id, Types::Integer
    attribute :in_production, Types::Bool
    attribute :name, Types::String
    attribute :number_of_episodes, Types::Integer
    attribute :number_of_seasons, Types::Integer
    attribute :popularity, Types::Float
    attribute :poster_path, Types::String
    attribute :seasons, Types::Array do
      attribute :air_date, Types::String.optional
      attribute :episode_count, Types::Integer
      attribute :id, Types::Integer
      attribute :name, Types::String
      attribute :poster_path, Types::String.optional
      attribute :season_number, Types::Integer
    end
    attribute :status, Types::String
  end
end
