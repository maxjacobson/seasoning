require "application_system_test_case"

# System tests for the activity feed widget on the shows page
class ActivityFeedTest < ApplicationSystemTestCase
  test "shows activity from followed humans" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    # Donna follows Cameron
    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    # Create a show and season
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Cameron writes a review
    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Amazing first season!",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    # Donna visits the shows page
    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Should see activity feed header
    assert_text "Activity"

    # Should see Cameron's review activity
    assert_text "cameron"
    assert_text "reviewed"
    assert_text "Season 1"
    assert_text "Halt and Catch Fire"
    assert_text "ago"
  end

  test "shows empty state when user follows nobody" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    assert_text "Activity"
    assert_text "No recent activity from people you follow."
  end

  test "shows empty state when followed humans have no recent reviews" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    # Donna follows Cameron but Cameron hasn't written any reviews
    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    assert_text "Activity"
    assert_text "No recent activity from people you follow."
  end

  test "does not show private reviews in activity feed" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Cameron writes a private review
    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Private thoughts",
      viewing: 1,
      visibility: "viewable_by_only_me"
    )

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Should not see private review
    assert_text "Activity"
    assert_text "No recent activity from people you follow."
    assert_no_text "Private thoughts"
  end

  test "shows multiple reviews from multiple followed humans" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")
    gordon = Human.create!(handle: "gordon", email: "gordon@example.com")

    # Donna follows both Cameron and Gordon
    Follow.create!(follower_id: donna.id, followee_id: cameron.id)
    Follow.create!(follower_id: donna.id, followee_id: gordon.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Both write reviews
    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Cameron's review",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    SeasonReview.create!(
      author: gordon,
      season: season,
      body: "Gordon's review",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Should see both reviews
    assert_text "cameron"
    assert_text "gordon"
  end

  test "does not show reviews from unfollowed humans" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")
    gordon = Human.create!(handle: "gordon", email: "gordon@example.com")

    # Donna only follows Cameron
    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Cameron writes a review
    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Cameron's review",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    # Gordon writes a review but Donna doesn't follow Gordon
    SeasonReview.create!(
      author: gordon,
      season: season,
      body: "Gordon's review",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Should only see Cameron's review
    assert_text "cameron"
    assert_no_text "gordon"
  end

  test "activity feed has clickable links to author profile" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Great season",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Click on Cameron's handle
    within "[data-test-id='activity-feed']" do
      click_link "cameron"
    end

    # Should be on Cameron's profile page
    assert_current_path "/cameron"
  end

  test "activity feed has clickable links to show page" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Great season",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Click on show title
    within "[data-test-id='activity-feed']" do
      click_link "Halt and Catch Fire"
    end

    # Should be on show page
    assert_current_path "/shows/halt-and-catch-fire"
  end

  test "activity feed has clickable links to season page" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Great season",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Click on season name
    within "[data-test-id='activity-feed']" do
      click_link "Season 1"
    end

    # Should be on season page
    assert_current_path "/shows/halt-and-catch-fire/season-1"
  end

  test "clicking poster in activity feed takes you to the review" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Amazing first season!",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    magic_link = MagicLink.create!(email: donna.email)
    visit redeem_magic_link_path(magic_link.token)
    visit shows_path

    # Click on the poster image
    within "[data-test-id='activity-feed']" do
      find("img[alt='Halt and Catch Fire poster']").click
    end

    # Should be on the review page (first viewing doesn't include viewing number in URL)
    assert_current_path "/cameron/shows/halt-and-catch-fire/season-1"
    assert_text "Amazing first season!"
  end
end
