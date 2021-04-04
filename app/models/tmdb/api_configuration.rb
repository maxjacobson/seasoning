# frozen_string_literal: true

module TMDB
  class APIConfiguration < Dry::Struct
    attribute :images do
      attribute :secure_base_url, Types::String
      attribute :poster_sizes, Types::Array.of(Types::String)
    end
  end
end
