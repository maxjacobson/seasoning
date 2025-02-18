require "application_system_test_case"

# System test for /shows page
class FilteringShowsTest < ApplicationSystemTestCase
  setup do
    human = Human.create!(handle: "cam", email: "cam@example.com")
    @magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(@magic_link.token)

    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 1234)
    note_to_self = <<~MARKDOWN
      # hello

      yes

      - wow
      - ok
      - cool
    MARKDOWN
    MyShow.create!(human:, show:, status: "might_watch", note_to_self:)
  end

  test "seeing unfiltered list" do
    visit shows_path

    assert page.has_content?("Halt and Catch Fire")
  end

  test "filtering by title" do
    visit shows_path

    fill_in "Filter your shows", with: "Sopranos"
    click_on "Apply filters"

    assert page.has_content?("No shows yet")

    fill_in "Filter your shows", with: "Fire"
    click_on "Apply filters"

    assert page.has_content?("Halt and Catch Fire")
  end

  test "filtering by status" do
    visit shows_path

    select "Currently watching", from: "statuses"
    click_on "Apply filters"

    assert page.has_content?("No shows yet")
  end
end
