# A person's review of a season of a show
class SeasonReview < ApplicationRecord
  enum :visibility, {
    viewable_by_anybody: "anybody",
    viewable_by_only_me: "myself"
  }

  belongs_to :author, class_name: "Human"
  belongs_to :season

  validates :rating, inclusion: { in: (0..10).to_a }, allow_blank: true
  validates :body, presence: true

  scope :authored_by, lambda { |viewer|
    where(author: viewer)
  }

  scope :viewable_by, lambda { |viewer|
    viewable_by_anybody.or(authored_by(viewer))
  }
end
