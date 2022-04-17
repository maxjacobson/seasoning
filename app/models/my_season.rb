# frozen_string_literal: true

# A person's relationship to a particular season
class MySeason < ApplicationRecord
  belongs_to :human
  belongs_to :season

  def reviews
    SeasonReview.where(season:, author: human)
  end
end
