require "application_system_test_case"

# System tests for the reviews page pagination
class ReviewsPageTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "donna",
      email: "donna@example.com"
    )
    @magic_link = MagicLink.create!(email: @human.email)
  end

  test "can view reviews page" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Your page"
    click_on "reviews (0)"

    assert_current_path "/donna/reviews"
  end

  test "shows no reviews message when user has no reviews" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Your page"
    click_on "reviews (0)"

    assert_text "No reviews yet!"
    assert_no_text "Page"
  end

  test "pagination works with multiple pages" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Create 35 reviews to test pagination (30 per page)
    35.times do |i|
      SeasonReview.create!(
        author: @human,
        season: season,
        rating: 5,
        body: "Review #{i}",
        viewing: i + 1
      )
    end

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Your page"
    click_on "reviews (35)"

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

  test "handles invalid page parameter gracefully" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Create enough reviews to have pagination
    35.times do |i|
      SeasonReview.create!(
        author: @human,
        season: season,
        rating: 5,
        body: "Review #{i}",
        viewing: i + 1
      )
    end

    visit redeem_magic_link_path(@magic_link.token)
    click_on "Your page"
    click_on "reviews (35)"

    # Test by manually navigating to invalid page (simulating typing in URL)
    visit "/#{@human.handle}/reviews?page=-1"

    assert_text "Page 1"

    visit "/#{@human.handle}/reviews?page=abc"

    assert_text "Page 1"
  end
end
