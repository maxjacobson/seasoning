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

  scope :viewable_by, lambda { |viewer|
    joins(<<~SQL.squish)
      join humans authors on authors.id = season_reviews.author_id
      left outer join follows author_followers on author_followers.follower_id = authors.id
      left outer join follows author_follows on author_follows.followee_id = authors.id
    SQL
      .where(<<~SQL.squish, viewer_id: viewer&.id)
        (visibility = 'anybody')
        or (
          visibility = 'myself'
          and author_id = :viewer_id
        ) or (
          visibility = 'mutuals'
          and author_followers.follower_id = author_follows.followee_id
          and author_follows.follower_id = author_followers.followee_id
        )
      SQL
      .distinct
  }

  scope :of_interest_to, lambda { |viewer|
    where(author: viewer).or(
      where(author: viewer.followings)
    )
  }
end
