# frozen_string_literal: true

# A link we email you so you can log in or sign up
class MagicLink < ApplicationRecord
  before_create -> { self.token = SecureRandom.uuid }
  before_create -> { self.expires_at = 30.minutes.from_now }

  def deliver
    # TODO
  end
end
