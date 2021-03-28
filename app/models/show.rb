# frozen_string_literal: true

class Show < ApplicationRecord
  before_create -> { self.slug = title&.gsub(/[^a-z0-9\s]/i, "")&.parameterize }
  has_many :seasons
end
