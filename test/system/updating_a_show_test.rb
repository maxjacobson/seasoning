require "application_system_test_case"

# After adding a show you can update some stuff about it
class UpdatingAShowTest < ApplicationSystemTestCase
  setup do
    human = Human.create!(handle: "cam", email: "cam@example.com", currently_watching_limit: 1)
    @magic_link = MagicLink.create!(email: human.email)

    # Create shows with proper TMDB IDs that match our test data
    Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659, slug: "halt-and-catch-fire")
    Show.create!(title: "Zoey's Extraordinary Playlist", tmdb_tv_id: 82_815, slug: "zoeys-extraordinary-playlist")

    # Mock TMDB API responses for searches
    stub_request(:get, "https://api.themoviedb.org/3/search/tv?api_key=xxxx&query=Halt")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/search-halt-and-catch-fire.json").read
      )

    stub_request(:get, "https://api.themoviedb.org/3/search/tv?api_key=xxxx&query=Zoey")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/search-zoey.json").read
      )

    visit redeem_magic_link_path(@magic_link.token)
  end

  test "can upate status" do
    fill_in "Search", with: "Halt"
    click_on "Search"
    # Click on the already imported show (TMDB ID 59659)
    click_link "imported-show-59659"

    assert_content "Added by: 0 people"
    click_on "Add"

    # Auto-submit happens when status changes
    select "Finished", from: "my_show[status]"

    assert_content "Updated Halt and Catch Fire"
  end

  test "can update note to self" do
    fill_in "Search", with: "Halt"
    click_on "Search"
    # Click on the already imported show (TMDB ID 59659)
    click_link "imported-show-59659"

    assert_content "Added by: 0 people"
    click_on "Add"

    click_on "Write note to self"
    fill_in "my_show[note_to_self]", with: "I love it so much"
    click_on "Update note to self"

    assert_content "Updated Halt and Catch Fire"
    assert_content "I love it so much"
  end

  test "currently watching limit is respected" do
    fill_in "Search", with: "Halt"
    click_on "Search"
    # Click on the already imported show (TMDB ID 59659)
    click_link "imported-show-59659"

    assert_content "Added by: 0 people"
    click_on "Add"

    select "Currently watching", from: "my_show[status]"

    assert_content "Updated Halt and Catch Fire"

    fill_in "Search", with: "Zoey"
    click_on "Search"
    # Click on the already imported show (TMDB ID 82815)
    click_link "imported-show-82815"

    assert_content "Added by: 0 people"
    click_on "Add"

    assert page.has_selector?("option[value='currently_watching'][disabled='disabled']")
  end
end
