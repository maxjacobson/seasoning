require "test_helper"

class SeasonReviewLikeTest < ActiveSupport::TestCase
  def setup
    @show = Show.create!(title: "The Bear", tmdb_tv_id: 100)
    @season = Season.create!(show: @show, name: "Season 1", season_number: 1, episode_count: 8, tmdb_id: 200)
    @author = Human.create!(handle: "carmen", email: "carmen@example.com")
    @reader = Human.create!(handle: "sydney", email: "sydney@example.com")
    @review = SeasonReview.create!(author: @author, season: @season, viewing: 1, body: "Loved it")
  end

  test "a human can like another human's review" do
    like = SeasonReviewLike.new(human: @reader, season_review: @review)
    assert like.valid?
  end

  test "a human cannot like their own review" do
    like = SeasonReviewLike.new(human: @author, season_review: @review)
    assert_not like.valid?
    assert_includes like.errors[:base], "Cannot like your own review"
  end

  test "a human cannot like the same review twice" do
    SeasonReviewLike.create!(human: @reader, season_review: @review)
    duplicate = SeasonReviewLike.new(human: @reader, season_review: @review)
    assert_raises(ActiveRecord::RecordNotUnique) { duplicate.save! }
  end

  test "destroying the review destroys the like" do
    SeasonReviewLike.create!(human: @reader, season_review: @review)
    assert_difference "SeasonReviewLike.count", -1 do
      @review.destroy!
    end
  end

  test "destroying the human destroys the like" do
    SeasonReviewLike.create!(human: @reader, season_review: @review)
    assert_difference "SeasonReviewLike.count", -1 do
      @reader.destroy!
    end
  end

  test "SeasonReview#likes returns associated likes" do
    like = SeasonReviewLike.create!(human: @reader, season_review: @review)
    assert_includes @review.likes, like
  end
end
