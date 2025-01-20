# A link we email you so you can log in or sign up
class MagicLink < ApplicationRecord
  before_validation -> { self.email = email.to_s.strip.downcase.presence }
  before_create -> { self.token = SecureRandom.uuid }
  before_create -> { self.expires_at = 30.minutes.from_now }
  validates :email, email: true

  scope :active, -> { where("expires_at > now()") }
  scope :inactive, -> { where("expires_at < now()") }

  def deliver
    human = Human.find_by(email:)

    if human.present?
      MagicLinkMailer.log_in_email(email, token).deliver_now
    else
      MagicLinkMailer.welcome_email(email, token).deliver_now
    end
  end

  def to_param = token
end
