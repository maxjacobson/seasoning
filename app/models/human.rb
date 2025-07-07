# Basically a user
class Human < ApplicationRecord
  has_many :my_shows
  has_many :shows, through: :my_shows
  has_many :season_reviews, foreign_key: :author_id, inverse_of: :author

  normalizes :email, with: ->(email) { email.to_s.strip.downcase.presence }
  normalizes :handle, with: ->(handle) { handle.to_s.parameterize.underscore.presence }

  validates :handle, exclusion: { in: RESERVED_WORDS, message: "%<value>s is reserved" }
  validates :currently_watching_limit, numericality: { in: 1..10, allow_nil: true }

  def currently_watching
    shows.where(my_shows: { status: "currently_watching" }).alphabetical
  end

  def at_currently_watching_limit?
    return false if currently_watching_limit.nil?

    currently_watching.count >= currently_watching_limit
  end

  def followers
    human_ids = Follow.where(followee_id: id).pluck(:follower_id)
    Human.where(id: human_ids)
  end

  def followings
    human_ids = Follow.where(follower_id: id).pluck(:followee_id)
    Human.where(id: human_ids)
  end

  def follows?(other)
    Follow.find_by(follower_id: id, followee_id: other.id)
  end
end
