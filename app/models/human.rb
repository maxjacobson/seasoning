# Basically a user
class Human < ApplicationRecord
  has_secure_password validations: false

  has_many :my_shows, dependent: :destroy
  has_many :shows, through: :my_shows
  has_many :season_reviews, foreign_key: :author_id, inverse_of: :author, dependent: :destroy
  has_many :returning_show_notifications, dependent: :destroy

  normalizes :email, with: ->(email) { email.to_s.strip.downcase.presence }
  normalizes :handle, with: ->(handle) { handle.to_s.parameterize.underscore.presence }

  validates :handle, exclusion: { in: RESERVED_WORDS, message: "%<value>s is reserved" }
  validates :currently_watching_limit, numericality: { in: 1..10, allow_nil: true }
  validates :password, length: { minimum: 12 }, if: -> { password.present? }
  validates :password, confirmation: true, if: -> { password.present? }
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validate :time_zone_must_be_valid

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

  def time_zone
    ActiveSupport::TimeZone[time_zone_name]
  end

  def uses_password?
    password_digest.present?
  end

  private

  def time_zone_must_be_valid
    return if time_zone_name.blank?

    errors.add(:time_zone_name, "is not a valid time zone") if ActiveSupport::TimeZone[time_zone_name].nil?
  end
end
