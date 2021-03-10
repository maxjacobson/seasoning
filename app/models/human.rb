# frozen_string_literal: true

# Basically a user
class Human < ApplicationRecord
  has_many :browser_sessions
end
