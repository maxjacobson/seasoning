# Some helper methods for views (if any!)
module ApplicationHelper
  def markdown_to_html(text)
    Kramdown::Document.new(text, input: "GFM").to_html
  end

  # FIXME: idk what to call this
  def proper_review_path(review)
    base = "/#{review.author.handle}/shows/#{review.season.show.slug}/#{review.season.slug}"

    if review.viewing == 1
      base
    else
      "#{base}/#{review.viewing}"
    end
  end

  def seen_current_season_message(human, season)
    my_season = MySeason.find_by(human:, season:)
    denominator = season.episodes.count

    numerator = if my_season
                  my_season.watched_episode_numbers.count
                else
                  0
                end
    "#{numerator}/#{denominator}"
  end
end
