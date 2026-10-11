require "test_helper"

class ShowProviderTest < ActiveSupport::TestCase
  test "category must be one of the known categories" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, slug: "halt-and-catch-fire")
    provider = Provider.create!(name: "AMC+", tmdb_provider_id: 4_460)
    show_provider = show.show_providers.new(provider: provider, category: "beaming")

    assert_not show_provider.valid?
    assert_includes show_provider.errors[:category], "is not included in the list"

    show_provider.category = "flatrate"

    assert_predicate show_provider, :valid?
  end
end
