# frozen_string_literal: true

# Data about a particular human's relationship to a show
class MyShow < ApplicationRecord
  belongs_to :human
  belongs_to :show
  enum status: {
    might_watch: "might_watch",
    next_up: "next_up",
    currently_watching: "currently_watching",
    stopped_watching: "stopped_watching",
    waiting_for_more: "waiting_for_more",
    finished: "finished"
  }

  def any_new_unwatched_seasons?
    # might be nil
    most_recent_watched = MySeason
                          .joins(:season)
                          .where(
                            human:,
                            season: { show: }
                          )
                          .select(&:watched?)
                          .map(&:season_number)
                          .max

    most_recent_released = show.seasons.maximum(:season_number)

    most_recent_watched.present? && most_recent_watched < most_recent_released
  end
end
