require "application_system_test_case"

class SearchingTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "donna",
      email: "donna@example.com"
    )
    @magic_link = MagicLink.create!(email: @human.email)
  end

  test "searching for show in database shows database results with TMDB fallback link" do
    # Create a show in the database
    stub_request(:get, "https://api.themoviedb.org/3/search/tv?api_key=xxxx&query=halt%20and%20catch%20fire")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/search-halt-and-catch-fire.json").read
      )

    stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire.json").read
      )

    [1, 2, 3, 4].each do |season_number|
      stub_request(:get, "https://api.themoviedb.org/3/tv/59659/season/#{season_number}?api_key=xxxx")
        .to_return(
          status: 200,
          body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire-season-#{season_number}.json").read
        )
    end

    visit redeem_magic_link_path(@magic_link.token)

    # Import a show through normal flow
    fill_in "Search", with: "halt and catch fire"
    click_on "Search"

    assert_content "Halt and Catch Fire (2014)"

    click_button "import-show-59659"

    assert_content "You've imported Halt and Catch Fire! Thanks."
    assert_equal "/shows/halt-and-catch-fire", page.current_path

    # Now search for the show again - should show database results on search page
    visit search_path(q: "Halt and Catch Fire")

    # Should be on search page showing database results
    assert_equal "/search", page.current_path
    assert_content "Halt and Catch Fire"

    # Should show TMDB fallback link
    assert_content "Not seeing what you're looking for?"
    assert_link "Include results from TMDB"
  end

  test "searching for unknown show goes straight to TMDB" do
    stub_request(:get, "https://api.themoviedb.org/3/search/tv?api_key=xxxx&query=zoey")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/search-zoey.json").read
      )

    visit redeem_magic_link_path(@magic_link.token)

    fill_in "Search", with: "zoey"
    click_on "Search"

    # Should show TMDB results
    assert_content "Zoey's Extraordinary Playlist"
    # Should NOT show TMDB fallback link (no database results)
    assert_no_content "Not seeing what you're looking for?"
  end

  test "searching with tmdb=1 bypasses database and shows TMDB results" do
    stub_request(:get, "https://api.themoviedb.org/3/search/tv?api_key=xxxx&query=zoey")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/search-zoey.json").read
      )

    visit redeem_magic_link_path(@magic_link.token)

    # Visit search page with tmdb=1 param
    visit search_path(q: "zoey", tmdb: 1)

    # Should show TMDB results
    assert_content "Zoey's Extraordinary Playlist"
  end

  test "searching for multiple shows with same title shows both from database" do
    # Create two shows with the same title
    show_us = Show.create!(
      title: "The Office",
      slug: "the-office-us",
      tmdb_tv_id: 6594,
      first_air_date: Date.new(2005, 3, 24)
    )

    show_uk = Show.create!(
      title: "The Office",
      slug: "the-office-uk",
      tmdb_tv_id: 85_371,
      first_air_date: Date.new(2001, 7, 9)
    )

    # Add at least one season and episode to each show so the view can render properly
    Season.create!(
      show: show_us,
      season_number: 1,
      episode_count: 6,
      tmdb_id: 3962,
      name: "Season 1",
      slug: "season-1"
    )
    Season.create!(
      show: show_uk,
      season_number: 1,
      episode_count: 14,
      tmdb_id: 3949,
      name: "Season 1",
      slug: "season-1"
    )

    visit redeem_magic_link_path(@magic_link.token)

    fill_in "Search", with: "The Office"
    click_on "Search"

    # Should show both versions
    assert_content "The Office"
    # Should have two results
    assert_equal 2, page.all("a[data-test-id^='imported-show-']").count
  end
end
