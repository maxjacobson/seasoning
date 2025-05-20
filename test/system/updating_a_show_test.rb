require "application_system_test_case"

# After adding a show you can update some stuff about it
class UpdatingAShowTest < ApplicationSystemTestCase
  setup do
    human = Human.create!(handle: "cam", email: "cam@example.com", currently_watching_limit: 1)
    @magic_link = MagicLink.create!(email: human.email)

    Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 1)
    Show.create!(title: "Zoey's Extraordinary Playlist", tmdb_tv_id: 2)
    visit redeem_magic_link_path(@magic_link.token)
  end

  test "can upate status" do
    fill_in "Search", with: "Halt"
    click_on "Search"
    click_on "Halt and Catch Fire"
    click_on "Add"
    select "Finished", from: "my_show[status]"
    click_on "Update status"

    assert page.has_content?("Updated Halt and Catch Fire")
  end

  test "can update note to self" do
    fill_in "Search", with: "Halt"
    click_on "Search"
    click_on "Halt and Catch Fire"
    click_on "Add"
    click_on "Write note to self"
    fill_in "my_show[note_to_self]", with: "I love it so much"
    click_on "Update note to self"

    assert page.has_content?("Updated Halt and Catch Fire")
    assert page.has_content?("I love it so much")
  end

  test "currently watching limit is respected" do
    fill_in "Search", with: "Halt"
    click_on "Search"
    click_on "Halt and Catch Fire"
    click_on "Add"

    select "Currently watching", from: "my_show[status]"
    click_on "Update status"

    assert page.has_content?("Updated Halt and Catch Fire")
    fill_in "Search", with: "Zoey"
    click_on "Search"
    click_on "Zoey's Extraordinary Playlist"
    click_on "Add"

    assert page.has_selector?("option[value='currently_watching'][disabled='disabled']")
  end
end
