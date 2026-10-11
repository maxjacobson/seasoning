require "test_helper"

class ProviderTest < ActiveSupport::TestCase
  test "logo url uses the preferred logo size" do
    provider = Provider.new(name: "AMC+", tmdb_provider_id: 4_460, tmdb_logo_path: "/logo.jpg")

    assert_equal "https://image.tmdb.org/t/p/w154/logo.jpg", provider.logo.url
  end

  test "logo url is nil without a logo path" do
    provider = Provider.new(name: "AMC+", tmdb_provider_id: 4_460)

    assert_nil provider.logo.url
  end
end
