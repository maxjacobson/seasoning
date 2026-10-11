module TMDB
  # Wraps the response from /tv/{id}/watch/providers
  # Data comes from JustWatch, via TMDB
  class WatchProviders < Dry::Struct
    class Provider < Dry::Struct
      attribute :display_priority, Types::Integer
      attribute :logo_path, Types::String.optional
      attribute :provider_id, Types::Integer
      attribute :provider_name, Types::String
    end

    class Region < Dry::Struct
      attribute :link, Types::String.optional.default(nil)
      attribute :flatrate, Types::Array.of(Provider).default([].freeze)
      attribute :rent, Types::Array.of(Provider).default([].freeze)
      attribute :buy, Types::Array.of(Provider).default([].freeze)
      attribute :free, Types::Array.of(Provider).default([].freeze)
      attribute :ads, Types::Array.of(Provider).default([].freeze)
    end

    attribute :id, Types::Integer
    attribute :results, Types::Hash

    def region(code)
      Region.new(results[code.to_sym] || {})
    end
  end
end
