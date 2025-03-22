# Some helper methods for views (if any!)
module ApplicationHelper
  def markdown_to_html(text)
    Kramdown::Document.new(text, input: "GFM").to_html
  end

  # Generate the proper path for a season review
  def proper_review_path(review)
    if review.viewing == 1
      profile_season_review_path(
        handle: review.author.handle,
        show: review.season.show.slug,
        season: review.season.slug
      )
    else
      profile_season_review_viewing_path(
        handle: review.author.handle,
        show: review.season.show.slug,
        season: review.season.slug,
        viewing: review.viewing
      )
    end
  end
end
