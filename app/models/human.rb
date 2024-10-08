# Basically a user
class Human < ApplicationRecord
  has_many :browser_sessions
  has_many :my_shows
  has_many :shows, through: :my_shows
  has_many :season_reviews, foreign_key: :author_id, inverse_of: :author

  before_validation ->(human) { human.handle = human.handle.to_s.parameterize.underscore.presence }
  before_save ->(human) { human.email = human.email.to_s.strip.downcase.presence }

  validates :handle, exclusion: { in: RESERVED_WORDS, message: "%<value>s is reserved" }
  validates :currently_watching_limit, numericality: { in: 1..10, allow_nil: true }

  def followers
    human_ids = Follow.where(followee_id: id).pluck(:follower_id)
    Human.where(id: human_ids)
  end

  def followings
    human_ids = Follow.where(follower_id: id).pluck(:followee_id)
    Human.where(id: human_ids)
  end
end
