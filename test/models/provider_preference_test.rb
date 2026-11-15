require "test_helper"

class ProviderPreferenceTest < ActiveSupport::TestCase
  test "pinned? and hidden? reflect the status" do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    provider = Provider.create!(name: "AMC+", tmdb_provider_id: 4_460)
    pinned = ProviderPreference.create!(human: human, provider: provider, status: "pinned")

    assert_predicate pinned, :pinned?
    assert_not_predicate pinned, :hidden?

    pinned.update!(status: "hidden")

    assert_predicate pinned, :hidden?
    assert_not_predicate pinned, :pinned?
  end

  test "rejects a status that isn't pinned or hidden" do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    provider = Provider.create!(name: "AMC+", tmdb_provider_id: 4_460)
    preference = ProviderPreference.new(human: human, provider: provider)

    assert_raises(ArgumentError) { preference.status = "meh" }
  end

  test "pinned_providers_by_show_id maps show ids to pinned providers" do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    amc_plus = Provider.create!(name: "AMC+", tmdb_provider_id: 4_460)
    apple_tv = Provider.create!(name: "Apple TV", tmdb_provider_id: 350)
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, slug: "halt-and-catch-fire")
    show.show_providers.create!(provider: amc_plus, category: "flatrate", display_priority: 6)
    show.show_providers.create!(provider: apple_tv, category: "buy", display_priority: 2)
    ProviderPreference.create!(human: human, provider: amc_plus, status: "pinned")

    result = human.pinned_providers_by_show_id([show.id])

    assert_equal [amc_plus], result[show.id]
  end

  test "pinned_providers_by_show_id excludes hidden providers" do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    amc_plus = Provider.create!(name: "AMC+", tmdb_provider_id: 4_460)
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, slug: "halt-and-catch-fire")
    show.show_providers.create!(provider: amc_plus, category: "flatrate", display_priority: 6)
    ProviderPreference.create!(human: human, provider: amc_plus, status: "hidden")

    result = human.pinned_providers_by_show_id([show.id])

    assert_nil result[show.id]
  end

  test "pinned_providers_by_show_id returns an empty hash when there are no pinned providers" do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, slug: "halt-and-catch-fire")

    assert_equal({}, human.pinned_providers_by_show_id([show.id]))
  end

  test "pinned_providers_by_show_id returns a provider once even if it has multiple categories" do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    amc_plus = Provider.create!(name: "AMC+", tmdb_provider_id: 4_460)
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, slug: "halt-and-catch-fire")
    show.show_providers.create!(provider: amc_plus, category: "flatrate", display_priority: 6)
    show.show_providers.create!(provider: amc_plus, category: "ads", display_priority: 1)
    ProviderPreference.create!(human: human, provider: amc_plus, status: "pinned")

    result = human.pinned_providers_by_show_id([show.id])

    assert_equal [amc_plus], result[show.id]
  end
end
