require "test_helper"

# unit tests for Human model
class HumanTest < ActiveSupport::TestCase
  test "it normalizes handles to a slug-like thing" do
    human = Human.create!(handle: "Marc Paffi", email: "marc@example.com")

    assert_equal "marc_paffi", human.handle
  end

  test "can create human without password" do
    human = Human.create!(
      handle: "donna",
      email: "donna@example.com"
    )

    assert_not human.uses_password?
  end

  test "can create human with password" do
    human = Human.create!(
      handle: "cameron",
      email: "cameron@example.com",
      password: "mutiny-forever-1985",
      password_confirmation: "mutiny-forever-1985"
    )

    assert_predicate human, :uses_password?
    assert human.authenticate("mutiny-forever-1985")
  end

  test "password must be at least 12 characters" do
    human = Human.new(
      handle: "gordon",
      email: "gordon@example.com",
      password: "short",
      password_confirmation: "short"
    )

    assert_not human.valid?
    assert_includes human.errors[:password], "is too short (minimum is 12 characters)"
  end

  test "password confirmation must match" do
    human = Human.new(
      handle: "joe",
      email: "joe@example.com",
      password: "long-enough-password",
      password_confirmation: "different-password"
    )

    assert_not human.valid?
    assert_includes human.errors[:password_confirmation], "doesn't match Password"
  end

  test "can add password to existing passwordless account" do
    human = Human.create!(
      handle: "bosworth",
      email: "bosworth@example.com"
    )

    assert_not human.uses_password?

    human.update!(
      password: "cardiff-electric-1983",
      password_confirmation: "cardiff-electric-1983"
    )

    human.reload

    assert_predicate human, :uses_password?
    assert human.authenticate("cardiff-electric-1983")
  end

  test "can change existing password" do
    human = Human.create!(
      handle: "haley",
      email: "haley@example.com",
      password: "old-password-here-long",
      password_confirmation: "old-password-here-long"
    )

    human.update!(
      password: "new-password-here-long",
      password_confirmation: "new-password-here-long"
    )

    human.reload

    assert human.authenticate("new-password-here-long")
    assert_not human.authenticate("old-password-here-long")
  end

  test "has default time zone" do
    human = Human.create!(
      handle: "joanie",
      email: "joanie@example.com"
    )

    assert_equal "Eastern Time (US & Canada)", human.time_zone_name
  end

  test "time_zone returns ActiveSupport::TimeZone object" do
    human = Human.create!(
      handle: "ryan",
      email: "ryan@example.com"
    )

    assert_instance_of ActiveSupport::TimeZone, human.time_zone
    assert_equal "Eastern Time (US & Canada)", human.time_zone.name
  end

  test "can update time zone" do
    human = Human.create!(
      handle: "bos",
      email: "bos@example.com"
    )

    human.update!(time_zone_name: "Pacific Time (US & Canada)")
    human.reload

    assert_equal "Pacific Time (US & Canada)", human.time_zone_name
    assert_equal "America/Los_Angeles", human.time_zone.tzinfo.name
  end

  test "accepts valid time zone names" do
    human = Human.new(
      handle: "alice",
      email: "alice@example.com",
      time_zone_name: "Central Time (US & Canada)"
    )

    assert_predicate human, :valid?
  end

  test "rejects invalid time zone names" do
    human = Human.new(
      handle: "bob",
      email: "bob@example.com",
      time_zone_name: "Not A Real Time Zone"
    )

    assert_not human.valid?
    assert_includes human.errors[:time_zone_name], "is not a valid time zone"
  end

  test "time_zone object can call today" do
    human = Human.create!(
      handle: "jacob",
      email: "jacob@example.com",
      time_zone_name: "Hawaii"
    )

    assert_respond_to human.time_zone, :today
    assert_instance_of Date, human.time_zone.today
  end

  test "recent_activity_reviews returns reviews from followed humans" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")
    gordon = Human.create!(handle: "gordon", email: "gordon@example.com")

    # Donna follows Cameron
    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    # Create a show and season
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Cameron writes a review
    cameron_review = SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Great season!",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    # Gordon writes a review (Donna doesn't follow Gordon)
    SeasonReview.create!(
      author: gordon,
      season: season,
      body: "Also great!",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    # Donna should only see Cameron's review
    reviews = donna.recent_activity_reviews

    assert_equal 1, reviews.count
    assert_equal cameron_review.id, reviews.first.id
  end

  test "recent_activity_reviews respects visibility settings" do
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
      body: "Private review",
      viewing: 1,
      visibility: "viewable_by_only_me"
    )

    # Cameron writes a public review
    public_review = SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Public review",
      viewing: 2,
      visibility: "viewable_by_anybody"
    )

    # Donna should only see the public review
    reviews = donna.recent_activity_reviews

    assert_equal 1, reviews.count
    assert_equal public_review.id, reviews.first.id
  end

  test "recent_activity_reviews filters by time window" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Recent review
    recent_review = SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Recent review",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    # Old review (created 31 days ago)
    travel_to 31.days.ago do
      SeasonReview.create!(
        author: cameron,
        season: season,
        body: "Old review",
        viewing: 2,
        visibility: "viewable_by_anybody"
      )
    end

    # Should only see recent review
    reviews = donna.recent_activity_reviews

    assert_equal 1, reviews.count
    assert_equal recent_review.id, reviews.first.id
  end

  test "recent_activity_reviews respects limit" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Create 20 reviews
    20.times do |i|
      SeasonReview.create!(
        author: cameron,
        season: season,
        body: "Review #{i}",
        viewing: i + 1,
        visibility: "viewable_by_anybody"
      )
    end

    # Should only return 15 (default limit)
    reviews = donna.recent_activity_reviews

    assert_equal 15, reviews.count
  end

  test "recent_activity_reviews returns empty when user follows nobody" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")

    reviews = donna.recent_activity_reviews

    assert_equal 0, reviews.count
  end

  test "recent_activity_reviews orders by most recent first" do
    donna = Human.create!(handle: "donna", email: "donna@example.com")
    cameron = Human.create!(handle: "cameron", email: "cameron@example.com")

    Follow.create!(follower_id: donna.id, followee_id: cameron.id)

    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 1)
    season = Season.create!(show: show, name: "Season 1", slug: "season-1", season_number: 1, tmdb_id: 1,
                            episode_count: 10)

    # Create reviews in non-chronological order
    first_review = SeasonReview.create!(
      author: cameron,
      season: season,
      body: "First review",
      viewing: 1,
      visibility: "viewable_by_anybody"
    )

    second_review = SeasonReview.create!(
      author: cameron,
      season: season,
      body: "Second review",
      viewing: 2,
      visibility: "viewable_by_anybody"
    )

    reviews = donna.recent_activity_reviews

    assert_equal 2, reviews.count
    assert_equal second_review.id, reviews.first.id
    assert_equal first_review.id, reviews.last.id
  end
end
