# frozen_string_literal: true

# Basically a user
class Human < ApplicationRecord
  has_many :browser_sessions
  has_many :my_shows
  has_many :shows, through: :my_shows

  before_save ->(human) { human.handle = human.handle.to_s.parameterize.presence }
end
