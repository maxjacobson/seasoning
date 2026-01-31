require "application_system_test_case"

class StatsPageTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "donna",
      email: "donna@example.com"
    )
    @magic_link = MagicLink.create!(email: @human.email)
  end

  test "user can navigate directly to their stats year page" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1988"

    assert_content "donna"
    assert_equal "/donna/stats/1988", page.current_path
  end

  test "user is redirected to current year when visiting stats index" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats"

    assert_content "donna"
    assert_match %r{/donna/stats/\d{4}}, page.current_path
  end

  test "user cannot view another user's stats page" do
    Human.create!(
      handle: "cameron",
      email: "cameron@example.com"
    )

    visit redeem_magic_link_path(@magic_link.token)
    visit "/cameron/stats/1988"

    assert_content "401 Unauthorized"
  end

  test "visiting a future year returns 404" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/3000"

    assert_content "The page you were looking for doesn't exist"
  end

  test "displays review count in hero section" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    season = Season.create!(show: show, tmdb_id: 23_456, name: "Season 1", season_number: 1, episode_count: 10,
                            slug: "season-1")

    SeasonReview.create!(
      author: @human,
      season: season,
      body: "Great show!",
      rating: 8,
      viewing: 1,
      created_at: Date.new(1988, 5, 15)
    )

    SeasonReview.create!(
      author: @human,
      season: season,
      body: "Still great!",
      rating: 9,
      viewing: 2,
      created_at: Date.new(1988, 8, 20)
    )

    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1988"

    assert_content "donna reviewed 2 seasons in 1988"
  end

  test "displays top 10 favorite seasons with ratings" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    season1 = Season.create!(show: show, tmdb_id: 23_456, name: "Season 1", season_number: 1, episode_count: 10,
                             slug: "season-1")
    season2 = Season.create!(show: show, tmdb_id: 23_457, name: "Season 2", season_number: 2, episode_count: 10,
                             slug: "season-2")

    # Create reviews with different ratings (higher rating should appear first)
    SeasonReview.create!(
      author: @human,
      season: season1,
      body: "Good season!",
      rating: 7,
      viewing: 1,
      created_at: Date.new(1988, 5, 15)
    )

    SeasonReview.create!(
      author: @human,
      season: season2,
      body: "Amazing season!",
      rating: 10,
      viewing: 1,
      created_at: Date.new(1988, 8, 20)
    )

    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1988"

    # Check that seasons are displayed with ratings, ordered by rating
    within first(".top-favorites") do
      assert_content "Halt and Catch Fire - Season 2"
      assert_content "★ ★ ★ ★ ★ ★ ★ ★ ★ ★"  # 10 stars
      assert_content "Halt and Catch Fire - Season 1"
      assert_content "★ ★ ★ ★ ★ ★ ★ ☆ ☆ ☆"  # 7 stars
    end
  end

  test "displays year navigation links" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1989"

    within ".year-navigation" do
      assert_link "← 1988", href: "/donna/stats/1988?filter=reviewed-in"
      assert_link "1990 →", href: "/donna/stats/1990?filter=reviewed-in"
    end
  end

  test "year navigation does not link to future years" do
    visit redeem_magic_link_path(@magic_link.token)

    # Visit a year that's close to current year to test future year logic
    current_year = Date.current.year
    visit "/donna/stats/#{current_year}"

    within ".year-navigation" do
      assert_link "← #{current_year - 1}", href: "/donna/stats/#{current_year - 1}?filter=reviewed-in"
      assert_no_link "#{current_year + 1} →"
    end
  end

  test "displays zero state when no reviews exist for the year" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1987"

    assert_content "donna reviewed 0 seasons in 1987"
    assert_no_css ".top-favorites"
    assert_content "No reviews yet!"
  end

  test "shows stats link on own profile page but not on others" do
    Human.create!(
      handle: "gordon",
      email: "gordon@example.com"
    )

    # Visit own profile - should show stats link
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna"

    assert_link "Stats", href: "/donna/stats"

    # Visit someone else's profile - should not show stats link
    visit "/gordon"

    assert_no_link "Stats"
  end

  test "redirects to reviewed-in filter by default" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1988"

    assert_includes page.current_url, "filter=reviewed-in"
  end

  test "displays toggle between reviewed-in and aired-in filters" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1988?filter=reviewed-in"

    assert_link "Reviewed in 1988", href: "/donna/stats/1988?filter=reviewed-in"
    assert_link "Aired in 1988", href: "/donna/stats/1988?filter=aired-in"

    assert_selector "a[aria-current='page']", text: "Reviewed in 1988"
    assert_no_selector "a[aria-current='page']", text: "Aired in 1988"
  end

  test "filter toggle preserves year in navigation" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1989?filter=aired-in"

    within ".year-navigation" do
      assert_link "← 1988", href: "/donna/stats/1988?filter=aired-in"
      assert_link "1990 →", href: "/donna/stats/1990?filter=aired-in"
    end
  end

  test "shows different content for aired-in filter" do
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)

    # Season that aired in 1988
    season_aired_in_1988 = Season.create!(
      show: show,
      tmdb_id: 23_456,
      name: "Season 1",
      season_number: 1,
      episode_count: 10,
      slug: "season-1",
      air_date: Date.new(1988, 3, 15)
    )

    # Season that aired in 1989
    season_aired_in_1989 = Season.create!(
      show: show,
      tmdb_id: 23_457,
      name: "Season 2",
      season_number: 2,
      episode_count: 10,
      slug: "season-2",
      air_date: Date.new(1989, 4, 20)
    )

    # Review both seasons in 1990
    SeasonReview.create!(
      author: @human,
      season: season_aired_in_1988,
      body: "Great retro season!",
      rating: 8,
      viewing: 1,
      created_at: Date.new(1990, 5, 15)
    )

    SeasonReview.create!(
      author: @human,
      season: season_aired_in_1989,
      body: "Good follow-up!",
      rating: 7,
      viewing: 1,
      created_at: Date.new(1990, 6, 20)
    )

    visit redeem_magic_link_path(@magic_link.token)

    # Test reviewed-in filter - should show both seasons
    visit "/donna/stats/1990?filter=reviewed-in"

    assert_content "donna reviewed 2 seasons in 1990"
    assert_content "Everything reviewed in 1990"

    # Test aired-in filter for 1988 - should show only season that aired in 1988
    visit "/donna/stats/1988?filter=aired-in"

    assert_content "donna reviewed 1 season that aired in 1988"
    assert_content "Everything that aired in 1988"
    assert_content "Halt and Catch Fire - Season 1"
    assert_no_content "Halt and Catch Fire - Season 2"

    # Test aired-in filter for 1989 - should show only season that aired in 1989
    visit "/donna/stats/1989?filter=aired-in"

    assert_content "donna reviewed 1 season that aired in 1989"
    assert_content "Everything that aired in 1989"
    assert_content "Halt and Catch Fire - Season 2"
    assert_no_content "Halt and Catch Fire - Season 1"
  end

  test "invalid filter parameter redirects to reviewed-in" do
    visit redeem_magic_link_path(@magic_link.token)
    visit "/donna/stats/1988?filter=invalid"

    assert_includes page.current_url, "filter=reviewed-in"
  end
end
