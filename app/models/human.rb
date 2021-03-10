# frozen_string_literal: true

# Basically a user
class Human < ApplicationRecord
  has_many :browser_sessions

  before_save ->(human) { human.handle = human.handle.to_s.parameterize.presence }
end
