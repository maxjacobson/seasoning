require "application_system_test_case"

class LikingSeasonReviewTest < ApplicationSystemTestCase
  setup do
    @show = Show.create!(title: "The Bear", tmdb_tv_id: 9999)
    @season = Season.create!(show: @show, name: "Season 1", season_number: 1, episode_count: 8, tmdb_id: 9999)

    @author = Human.create!(handle: "carmen", email: "carmen@example.com")
    @reader = Human.create!(handle: "sydney", email: "sydney@example.com")

    @review = SeasonReview.create!(
      author: @author,
      season: @season,
      viewing: 1,
      body: "The best show on TV right now.",
      visibility: "anybody"
    )

    @magic_link = MagicLink.create!(email: @reader.email)
  end

  test "logged-in user can like another person's review" do
    visit redeem_magic_link_path(@magic_link.token)
    visit profile_season_review_path(@author.handle, @show.slug, @season.slug)

    assert_content "0 likes"
    assert_button "Like"

    click_on "Like"

    assert_content "1 like"
    assert_button "Unlike"
    assert_equal 1, @review.likes.count
  end

  test "logged-in user can unlike a review they previously liked" do
    SeasonReviewLike.create!(human: @reader, season_review: @review)

    visit redeem_magic_link_path(@magic_link.token)
    visit profile_season_review_path(@author.handle, @show.slug, @season.slug)

    assert_content "1 like"
    assert_button "Unlike"

    click_on "Unlike"

    assert_content "0 likes"
    assert_button "Like"
    assert_equal 0, @review.likes.count
  end

  test "the review author does not see a like button on their own review" do
    author_magic_link = MagicLink.create!(email: @author.email)

    visit redeem_magic_link_path(author_magic_link.token)
    visit profile_season_review_path(@author.handle, @show.slug, @season.slug)

    assert_content "0 likes"
    assert_no_button "Like"
    assert_no_button "Unlike"
  end

  test "logged-out visitor sees the like count but no like button" do
    SeasonReviewLike.create!(human: @reader, season_review: @review)

    visit profile_season_review_path(@author.handle, @show.slug, @season.slug)

    assert_content "1 like"
    assert_no_button "Like"
    assert_no_button "Unlike"
  end

  test "like count appears in the season's review list" do
    SeasonReviewLike.create!(human: @reader, season_review: @review)

    reader_magic_link = MagicLink.create!(email: @reader.email)
    visit redeem_magic_link_path(reader_magic_link.token)
    visit season_path(@show.slug, @season.slug)

    assert_content "1 like"
  end
end
