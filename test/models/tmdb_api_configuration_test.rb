require "test_helper"

class TMDBAPIConfigurationTest < ActiveSupport::TestCase
  test "refresh! creates the record and then recreates it" do
    request = stub_request(:get, "https://api.themoviedb.org/3/configuration?api_key=xxxx")
              .to_return(status: 200,
                         body: Rails.root.join("test/webmock/tmdb/configuration.json").read)

    TMDBAPIConfiguration.refresh!

    assert_request_requested request
    assert_equal 1, TMDBAPIConfiguration.count

    TMDBAPIConfiguration.refresh!

    assert_equal 1, TMDBAPIConfiguration.count
  end
end
