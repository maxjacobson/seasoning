require "application_system_test_case"

# System test covering the season review creation flow
class CreatingSeasonReviewTest < ApplicationSystemTestCase
  setup do
    @human = Human.create!(
      handle: "donna",
      email: "donna@example.com",
      default_review_visibility: "anybody"
    )
    @magic_link = MagicLink.create!(email: @human.email)

    @show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 59_659)
    @season = Season.create!(
      show: @show,
      name: "Season 1",
      season_number: 1,
      episode_count: 10,
      tmdb_id: 62_139
    )

    # Create a MyShow so the show appears on the human's list
    @my_show = MyShow.create!(
      human: @human,
      show: @show,
      status: "currently_watching"
    )
  end

  test "creating a season review with rating and visibility" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "Add review"

    assert page.has_content?("New review of Halt and Catch Fire — Season 1")

    select "8 stars", from: "Rating"

    fill_in "Your review (you can use Markdown)",
            with: <<~TEXT.chomp
              The tech industry drama we needed. Incredible character development and period details.
            TEXT

    click_on "Save"

    assert_button "Delete review"
    assert page.has_content?("The tech industry drama we needed")

    review = SeasonReview.find_by(author: @human, season: @season)

    assert_not_nil review
    assert_equal "The tech industry drama we needed. Incredible character development and period details.", review.body
    assert_equal 8, review.rating
    assert_equal "viewable_by_anybody", review.visibility
    assert_equal 1, review.viewing
  end

  test "creating a review with no rating and private visibility" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "Add review"

    select "Only myself", from: "Visible to"

    fill_in "Your review (you can use Markdown)", with: "Just some personal notes for myself."
    click_on "Save"

    assert_button "Delete review"

    review = SeasonReview.find_by(author: @human, season: @season)

    assert_not_nil review
    assert_equal "Just some personal notes for myself.", review.body
    assert_nil review.rating
    assert_equal "viewable_by_only_me", review.visibility
    assert_equal 1, review.viewing
  end

  test "validation error when submitting empty review" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "Add review"

    click_on "Save"

    assert page.has_content?("Body can't be blank")
  end

  test "multiple reviews for same season create different viewing numbers" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "Add review"
    fill_in "Your review (you can use Markdown)", with: "First time watching - amazing tech drama!"
    click_on "Save"

    assert_button "Delete review"

    click_on "Season 1"
    click_on "Add review"

    fill_in "Your review (you can use Markdown)", with: "Second viewing - even better storytelling!"
    click_on "Save"

    assert_button "Delete review"

    reviews = SeasonReview.where(author: @human, season: @season).order(:viewing)

    assert_equal 2, reviews.count
    assert_equal 1, reviews.first.viewing
    assert_equal 2, reviews.second.viewing
    assert_equal "First time watching - amazing tech drama!", reviews.first.body
    assert_equal "Second viewing - even better storytelling!", reviews.second.body
  end

  test "deleting a review after creating it" do
    visit redeem_magic_link_path(@magic_link.token)
    click_on "Halt and Catch Fire"
    click_on "Season 1"
    click_on "Add review"

    fill_in "Your review (you can use Markdown)", with: "This review will be deleted."
    click_on "Save"

    assert_button "Delete review"
    assert page.has_content?("This review will be deleted.")

    review = SeasonReview.find_by(author: @human, season: @season)

    assert_not_nil review

    click_on "Delete review"

    # FIXME: Uncomment when SeasonPage is ported to ERB - SPA doesn't show flash messages
    # assert page.has_content?("Review deleted successfully")
    assert_equal "/shows/halt-and-catch-fire/season-1", current_path
    assert_text "Halt and Catch Fire"

    assert_nil SeasonReview.find_by(author: @human, season: @season)
  end
end
