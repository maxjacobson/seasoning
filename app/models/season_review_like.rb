class SeasonReviewLike < ApplicationRecord
  belongs_to :human
  belongs_to :season_review

  validate :cannot_like_own_review

  private

  def cannot_like_own_review
    return unless season_review && human
    return unless season_review.author == human

    errors.add(:base, "Cannot like your own review")
  end
end
