# frozen_string_literal: true

# Basically a user
class Human < ApplicationRecord
  has_many :browser_sessions
  has_many :my_shows
  has_many :shows, through: :my_shows

  before_save ->(human) { human.handle = human.handle.to_s.parameterize.presence }
  before_save ->(human) { human.email = human.email.to_s.strip.downcase.presence }

  def gravatar_url
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}"
  end
end
