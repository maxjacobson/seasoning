require "application_system_test_case"

class ShowProvidersPageTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(handle: "cam", email: "cam@example.com")
    @magic_link = MagicLink.create!(email: @human.email)

    @show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, slug: "halt-and-catch-fire")

    amc_plus = Provider.create!(name: "AMC+", tmdb_provider_id: 4_460, tmdb_logo_path: "/amc.jpg")
    apple_tv = Provider.create!(name: "Apple TV", tmdb_provider_id: 350, tmdb_logo_path: "/apple.jpg")
    @show.show_providers.create!(provider: amc_plus, category: "flatrate", display_priority: 6)
    @show.show_providers.create!(provider: apple_tv, category: "buy", display_priority: 2)
  end

  test "viewing the where-to-watch page from the show page" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_path(@show.slug)

    click_on "Where to watch"

    assert_content "Stream"
    assert_link "← Back", href: show_path(@show.slug)

    assert_equal "/shows/halt-and-catch-fire/providers", page.current_path
    assert_content "AMC+"
    assert_content "Buy"
    assert_content "Apple TV"
    assert_selector "[data-test-id='provider-4460']"
    assert_selector "img.provider-card__logo[src*='/amc.jpg']"

    assert_selector "[data-test-id='justwatch-attribution'] a[href='https://www.justwatch.com']", text: "JustWatch"
  end

  test "shows a friendly message when there is nowhere to watch the show" do
    @show.show_providers.destroy_all

    visit redeem_magic_link_path(@magic_link.token)
    visit show_providers_path(@show.slug)

    assert_selector "[data-test-id='no-providers']"
    assert_content "We don't know of anywhere to watch this show right now."
  end

  test "pinning a provider marks it and surfaces it on the show page" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_providers_path(@show.slug)

    find("[data-test-id='pin-4460']").click

    assert_selector "[data-test-id='provider-4460'].provider-card--pinned"
    assert_content "📌 AMC+"
    assert_selector "[data-test-id='unpin-4460']"

    visit show_path(@show.slug)

    assert_selector "[data-test-id='pinned-providers']"
    assert_selector "[data-test-id='pinned-providers'] img.pinned-providers__logo[alt='AMC+']"
    assert_selector "[data-test-id='pinned-providers'] img.pinned-providers__logo[alt='Apple TV']", count: 0
  end

  test "unpinning a provider removes the pin" do
    ProviderPreference.create!(human: @human, provider: Provider.find_by!(tmdb_provider_id: 4_460), status: "pinned")

    visit redeem_magic_link_path(@magic_link.token)
    visit show_providers_path(@show.slug)

    find("[data-test-id='unpin-4460']").click

    assert_selector "[data-test-id='provider-4460']:not(.provider-card--pinned)"
    assert_selector "[data-test-id='pin-4460']"
  end

  test "hiding a provider stops it from showing up on the where-to-watch page" do
    visit redeem_magic_link_path(@magic_link.token)
    visit show_providers_path(@show.slug)

    find("[data-test-id='hide-350']").click

    assert_selector "[data-test-id='provider-350']", count: 0
    assert_no_content "Apple TV"
    assert_content "AMC+"
  end

  test "hidden and pinned providers can be managed from settings" do
    apple_tv = Provider.find_by!(tmdb_provider_id: 350)
    ProviderPreference.create!(human: @human, provider: apple_tv, status: "hidden")

    visit redeem_magic_link_path(@magic_link.token)
    visit settings_path

    assert_selector "[data-test-id='provider-preference-#{apple_tv.id}']"
    assert_content "Apple TV"
    assert_content "Hidden"

    find("[data-test-id='unhide-#{apple_tv.id}']").click

    assert_selector "[data-test-id='provider-preference-#{apple_tv.id}']", count: 0
  end

  test "pinned providers show up on the shows index" do
    ProviderPreference.create!(human: @human, provider: Provider.find_by!(tmdb_provider_id: 4_460), status: "pinned")
    MyShow.create!(human: @human, show: @show, status: "currently_watching")

    visit redeem_magic_link_path(@magic_link.token)
    visit shows_path

    assert_selector "[data-test-id='pinned-providers'] img.pinned-providers__logo[alt='AMC+']"
  end
end
