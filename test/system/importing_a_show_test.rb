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
    visit redeem_magic_link_path(@magic_link.token)

    fill_in "Search", with: "halt and catch fire"
    click_on "Search"

    assert page.has_content?(
      <<~TEXT.squish
        Not seeing what you’re looking for?
        You might be the first person to want to add it.
        Feel free to import it here.
      TEXT
    )

    search_request = stub_request(:get, "https://api.themoviedb.org/3/search/tv?api_key=xxxx&query=halt%20and%20catch%20fire")
                     .to_return(
                       status: 200,
                       body: Rails.root.join("test/webmock/tmdb/search-halt-and-catch-fire.json").read
                     )

    click_on "import it here"

    assert_request_requested search_request

    assert page.has_content?("Halt and Catch Fire (2014)")

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

    click_on "Import"

    assert_request_requested tv_request, times: 2
    seasons_requests.each do |req|
      assert_request_requested req
    end

    assert_equal "/shows/halt-and-catch-fire", page.current_path

    assert page.has_content?("Halt and Catch Fire")
  end
end
