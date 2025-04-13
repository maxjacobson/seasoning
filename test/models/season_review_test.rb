require "test_helper"

# unit tests for SeasonReview model
class SeasonReviewTest < ActiveSupport::TestCase
  test ".viewable_by when the review is viewable by anybody and current human is present" do
    human = Human.create!(handle: "marc", email: "marc@example.com")
    show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
    season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
    review = SeasonReview.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "anybody")

    other_human = Human.create!(handle: "Ashley", email: "ashley@example.com")

    assert_includes SeasonReview.viewable_by(other_human), review
  end

  test ".viewable_by when the review is viewable by anybody and current human is nil" do
    human = Human.create!(handle: "marc", email: "marc@example.com")
    show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
    season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
    review = SeasonReview.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "anybody")

    assert_includes SeasonReview.viewable_by(nil), review
  end

  test ".viewable_by when the review is only viewable by the author and the viewer is the author" do
    human = Human.create!(handle: "marc", email: "marc@example.com")
    show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
    season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
    review = SeasonReview.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "myself")

    assert_includes SeasonReview.viewable_by(human), review
  end

  test ".viewable_by when the review is only viewable by the author and the viewer is someone else" do
    human = Human.create!(handle: "marc", email: "marc@example.com")
    show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
    season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
    review = SeasonReview.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "myself")
    other_human = Human.create!(handle: "Ashley", email: "ashley@example.com")

    assert_not_includes SeasonReview.viewable_by(other_human), review
  end

  test ".viewable_by when the review is only viewable by the author and the viewer is nil" do
    human = Human.create!(handle: "marc", email: "marc@example.com")
    show = Show.create!(title: "Home Economics", tmdb_tv_id: 1)
    season = Season.create!(show:, name: "Season 1", season_number: 1, episode_count: 10, tmdb_id: 1)
    review = SeasonReview.create!(author: human, season:, viewing: 1, body: "Not bad", visibility: "myself")

    assert_not_includes SeasonReview.viewable_by(nil), review
  end
end
