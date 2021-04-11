# frozen_string_literal: true

# A person's review of a season of a show
class SeasonReview < ApplicationRecord
  enum visibility: {
    viewable_by_anybody: "anybody",
    viewable_by_mutuals: "mutuals",
    viewable_by_only_me: "myself"
  }

  belongs_to :author, class_name: "Human"
  belongs_to :season

  validates :rating, inclusion: { in: (0..10).to_a }, allow_blank: true
  validates :body, presence: true

  def viewable_by?(human)
    if viewable_by_anybody?
      true
    elsif viewable_by_mutuals?
      human.present? &&
        human.followers.include?(author) &&
        author.followers.include?(human)
    elsif viewably_by_only_me?
      author == human
    else
      raise
    end
  end
end
