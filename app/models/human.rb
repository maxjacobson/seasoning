# frozen_string_literal: true

# Basically a user
class Human < ApplicationRecord
  has_many :browser_sessions
  has_many :my_shows
  has_many :shows, through: :my_shows

  before_validation ->(human) { human.handle = human.handle.to_s.parameterize.underscore.presence }
  before_save ->(human) { human.email = human.email.to_s.strip.downcase.presence }

  validates :handle, exclusion: { in: RESERVED_WORDS, message: "%<value>s is reserved" }

  def followers
    human_ids = Follow.where(followee_id: id).pluck(:follower_id)
    Human.where(id: human_ids)
  end

  def followings
    human_ids = Follow.where(follower_id: id).pluck(:followee_id)
    Human.where(id: human_ids)
  end

  def gravatar_url
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}"
  end
end
