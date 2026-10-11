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
end
