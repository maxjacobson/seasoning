# A person's relationship to a particular season
class MySeason < ApplicationRecord
  belongs_to :human
  belongs_to :season

  def reviews
    SeasonReview.where(season:, author: human)
  end

  def watched?
    watched_episode_numbers.uniq.sort == season.episodes.pluck(:episode_number).uniq.sort
  end

  def episode_watched?(episode_number)
    watched_episode_numbers.include?(episode_number)
  end
end
