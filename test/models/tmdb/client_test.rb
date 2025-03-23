require "test_helper"

module TMDB
  # unit tests for tmdb client
  class ClientTest < ActiveSupport::TestCase
    setup do
      @client = TMDB::Client.new
    end

    test "#tv_details" do
      response = JSON.parse(Rails.root.join("test/webmock/tmdb/halt-and-catch-fire.json").read)
      response["popularity"] = 0

      request = stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
                .to_return(
                  status: 200,
                  body: response.to_json
                )

      details = @client.tv_details(59_659)

      assert_equal 0, details.popularity
      assert_request_requested request
    end
  end
end
