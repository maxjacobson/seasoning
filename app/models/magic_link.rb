# frozen_string_literal: true

# A link we email you so you can log in or sign up
class MagicLink < ApplicationRecord
  before_create -> { self.token = SecureRandom.uuid }
  before_create -> { self.expires_at = 30.minutes.from_now }

  def deliver
    human = Human.where(email: email).first

    if human.present?
      MagicLinkMailer.log_in_email(email, token).deliver_now
    else
      MagicLinkMailer.welcome_email(email, token).deliver_now
    end
  end
end
