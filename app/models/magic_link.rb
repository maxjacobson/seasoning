# A link we email you so you can log in or sign up
class MagicLink < ApplicationRecord
  before_create -> { self.token = SecureRandom.uuid }
  before_create -> { self.expires_at = 30.minutes.from_now }

  scope :active, -> { where("expires_at > now()") }
  scope :inactive, -> { where("expires_at < now()") }

  normalizes :email, with: ->(email) { email.to_s.strip.downcase.presence }

  validates :email, email: true

  def recipient
    Human.find_by(email:)
  end

  def deliver
    if recipient.present?
      MagicLinkMailer.log_in_email(email, token).deliver_now
    else
      MagicLinkMailer.welcome_email(email, token).deliver_now
    end
  end
end
