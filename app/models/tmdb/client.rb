require "net/http"

module TMDB
  # API client for the movie database's API
  # https://developers.themoviedb.org/3/getting-started
  #
  class Client
    NotFound = Class.new(StandardError)

    def search_tv(query)
      data = get("/search/tv", query:)
      ::TMDB::TVSearchResults.new(data)
    end

    def tv_details(id)
      path = format("/tv/%d", id)
      data = get(path)
      ::TMDB::TVDetails.new(data)
    end

    def season_details(tv_id, season_number)
      path = "/tv/#{tv_id}/season/#{season_number}"
      data = get(path)
      ::TMDB::SeasonDetails.new(data)
    end

    def api_configuration
      data = get("/configuration")
      ::TMDB::APIConfiguration.new(data)
    end

    private

    def get(path, params = {})
      uri = URI("https://api.themoviedb.org/3")
      uri.path += path
      params["api_key"] = ENV.fetch("TMDB_API_KEY")
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri)

      raise NotFound, response.inspect if response.is_a?(Net::HTTPNotFound)
      raise response.inspect unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body).deep_symbolize_keys
    end
  end
end
