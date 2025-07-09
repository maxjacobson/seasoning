require "application_system_test_case"

# System tests for the shows page pagination
class ShowsPaginationTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "donna",
      email: "donna@example.com"
    )
    @magic_link = MagicLink.create!(email: @human.email)
  end

  test "shows pagination only when there are multiple pages" do
    # Create only 5 shows (less than PAGE_SIZE of 30)
    5.times do |i|
      show = Show.create!(title: "Show #{i}", slug: "show-#{i}", tmdb_tv_id: i + 1)
      MyShow.create!(human: @human, show: show, status: "currently_watching")
    end

    visit redeem_magic_link_path(@magic_link.token)

    # Should not show pagination controls
    assert_no_text "Page 1"
    assert_no_link "Next →"
    assert_no_link "← Previous"
  end

  test "shows pagination correctly with multiple pages" do
    # Create 35 shows (more than PAGE_SIZE of 30)
    35.times do |i|
      show = Show.create!(title: "Show #{i}", slug: "show-#{i}", tmdb_tv_id: i + 1)
      MyShow.create!(human: @human, show: show, status: "currently_watching")
    end

    visit redeem_magic_link_path(@magic_link.token)

    # First page should show pagination controls
    assert_text "Page 1"
    assert_link "Next →"
    assert_no_link "← Previous"

    # Go to second page
    click_on "Next →"

    assert_text "Page 2"
    assert_link "← Previous"
    assert_no_link "Next →"

    # Go back to first page
    click_on "← Previous"

    assert_text "Page 1"
    assert_link "Next →"
    assert_no_link "← Previous"
  end
end
