require "application_system_test_case"

# System test covering viewing a season review
class SeasonReviewPageTest < ApplicationSystemTestCase
  setup do
    @reviewer = Human.create!(
      handle: "reviewer",
      email: "reviewer@example.com"
    )

    @show = Show.create!(
      slug: "test-show",
      title: "Test Show",
      tmdb_tv_id: 12_345,
      tmdb_next_refresh_at: 1.day.from_now,
      tmdb_poster_path: "/test-poster.jpg"
    )

    @season = Season.create!(
      show: @show,
      slug: "season-1",
      name: "Season 1",
      tmdb_id: 67_890,
      season_number: 1,
      episode_count: 10,
      tmdb_poster_path: "/test-season-poster.jpg"
    )

    # Create an anybody review
    @anybody_review = SeasonReview.create!(
      author: @reviewer,
      season: @season,
      body: "This is an anybody review with **markdown**.",
      visibility: "anybody",
      rating: 8,
      viewing: 1
    )

    # Create a second review from the same author for the same season
    @second_viewing_review = SeasonReview.create!(
      author: @reviewer,
      season: @season,
      body: "This is my second viewing review.",
      visibility: "anybody",
      rating: 9,
      viewing: 2
    )

    # Create a mutuals-only review for a different season
    @other_season = Season.create!(
      show: @show,
      slug: "season-2",
      name: "Season 2",
      tmdb_id: 67_891,
      season_number: 2,
      episode_count: 8,
      tmdb_poster_path: "/test-season2-poster.jpg"
    )

    @mutuals_review = SeasonReview.create!(
      author: @reviewer,
      season: @other_season,
      body: "This is a mutuals-only review.",
      visibility: "mutuals",
      rating: 6,
      viewing: 1
    )

    # Create a myself-only review for a different season
    @another_season = Season.create!(
      show: @show,
      slug: "season-3",
      name: "Season 3",
      tmdb_id: 67_892,
      season_number: 3,
      episode_count: 12,
      tmdb_poster_path: "/test-season3-poster.jpg"
    )

    @myself_review = SeasonReview.create!(
      author: @reviewer,
      season: @another_season,
      body: "This is a myself-only review.",
      visibility: "myself",
      rating: 4,
      viewing: 1
    )

    # Create a mutual follower and non-follower for testing visibility
    @follower = Human.create!(
      handle: "follower",
      email: "follower@example.com"
    )
    # Create mutual follows
    Follow.create!(follower_id: @follower.id, followee_id: @reviewer.id)
    Follow.create!(follower_id: @reviewer.id, followee_id: @follower.id)

    @non_follower = Human.create!(
      handle: "visitor",
      email: "visitor@example.com"
    )
  end

  test "viewing an anybody review shows the correct content" do
    # Login as non-follower
    magic_link = MagicLink.create!(email: @non_follower.email)
    visit redeem_magic_link_path(magic_link.token)

    # Debug output to Rails logger
    Rails.logger.debug do
      "TEST DEBUG - @anybody_review ID: #{@anybody_review.id}, visibility: #{@anybody_review.visibility}"
    end

    # Visit the anybody review
    visit profile_season_review_path(
      handle: @reviewer.handle,
      show: @show.slug,
      season: @season.slug
    )

    assert_text "Test Show"
    assert_text "Season 1"
    assert_text "reviewer's review of Season 1 of Test Show"

    # Check if the review body is displayed with markdown
    assert_text "This is an anybody review with markdown"

    # Check for the date
    assert_text @anybody_review.created_at.to_date.to_s

    # Check for the star rating using the title attribute
    # Note: The exact star rendering mechanism is an implementation detail
    # so we'll just check the rating is visible through the title attribute
    assert_selector "span[title='8/10 rating']"
  end

  test "second viewing of a show can be accessed with the viewing parameter" do
    # Login
    magic_link = MagicLink.create!(email: @non_follower.email)
    visit redeem_magic_link_path(magic_link.token)

    # Visit the second viewing review
    visit profile_season_review_viewing_path(
      handle: @reviewer.handle,
      show: @show.slug,
      season: @season.slug,
      viewing: 2
    )

    assert_text "Test Show"
    assert_text "Season 1"
    assert_text "This is my second viewing review."

    # Check for the star rating (9/10)
    assert_selector "span[title='9/10 rating']"
  end

  test "mutuals can view mutuals-only reviews" do
    # Login as follower
    magic_link = MagicLink.create!(email: @follower.email)
    visit redeem_magic_link_path(magic_link.token)

    # Visit the mutuals-only review
    visit profile_season_review_path(
      handle: @reviewer.handle,
      show: @show.slug,
      season: @other_season.slug
    )

    assert_text "Season 2"
    assert_text "This is a mutuals-only review."
    assert_selector "span[title='6/10 rating']"
  end

  test "non-mutuals cannot view mutuals-only reviews" do
    # Login as non-follower
    magic_link = MagicLink.create!(email: @non_follower.email)
    visit redeem_magic_link_path(magic_link.token)

    # Debug output to Rails logger
    Rails.logger.debug do
      "TEST DEBUG - @mutuals_review ID: #{@mutuals_review.id}, visibility: #{@mutuals_review.visibility}"
    end

    # Try to visit the mutuals-only review - should get 401
    visit profile_season_review_path(
      handle: @reviewer.handle,
      show: @show.slug,
      season: @other_season.slug
    )

    # Should see the 401 unauthorized page
    assert_text "401 Unauthorized"
    assert_text "Go home"
  end

  test "only the author can view myself-only reviews" do
    # Login as the author
    magic_link = MagicLink.create!(email: @reviewer.email)
    visit redeem_magic_link_path(magic_link.token)

    # Visit the myself-only review
    visit profile_season_review_path(
      handle: @reviewer.handle,
      show: @show.slug,
      season: @another_season.slug
    )

    assert_text "Season 3"
    assert_text "This is a myself-only review."
    assert_selector "span[title='4/10 rating']"

    # Now try as a follower (shouldn't be able to view)
    magic_link = MagicLink.create!(email: @follower.email)
    visit redeem_magic_link_path(magic_link.token)

    # Should get 401 unauthorized
    visit profile_season_review_path(
      handle: @reviewer.handle,
      show: @show.slug,
      season: @another_season.slug
    )

    # Should see the 401 unauthorized page
    assert_text "401 Unauthorized"
    assert_text "Go home"
  end
end
