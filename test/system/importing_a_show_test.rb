require "application_system_test_case"

# System test covering viewing and upating settings
class ImportingAShowTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "cam",
      email: "cam@example.com"
    )
    @magic_link = MagicLink.create!(email: @human.email)
  end

  test "searching for and importing a show" do
    search_request = stub_request(:get, "https://api.themoviedb.org/3/search/tv?api_key=xxxx&query=halt%20and%20catch%20fire")
                     .to_return(
                       status: 200,
                       body: Rails.root.join("test/webmock/tmdb/search-halt-and-catch-fire.json").read
                     )

    visit redeem_magic_link_path(@magic_link.token)

    fill_in "Search", with: "halt and catch fire"
    click_on "Search"

    assert_content "Halt and Catch Fire (2014)"
    assert_request_requested search_request

    tv_request = stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
                 .to_return(
                   status: 200,
                   body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire.json").read
                 )

    seasons_requests = [1, 2, 3, 4].map do |season_number|
      stub_request(:get, "https://api.themoviedb.org/3/tv/59659/season/#{season_number}?api_key=xxxx")
        .to_return(
          status: 200,
          body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire-season-#{season_number}.json").read
        )
    end

    # Click on the poster to import the show (TMDB ID 59659 for Halt and Catch Fire)
    click_button "import-show-59659"

    assert_content "You've imported Halt and Catch Fire! Thanks."

    assert_request_requested tv_request, times: 2
    seasons_requests.each do |req|
      assert_request_requested req
    end

    assert_equal "/shows/halt-and-catch-fire", page.current_path

    select "Currently watching"

    click_on "Update status"

    assert_content "Updated Halt and Catch Fire"
  end
end
