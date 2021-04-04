# frozen_string_literal: true

# A TV show!
# Data is mostly from the movie database
class Show < ApplicationRecord
  before_create -> { self.slug = title&.gsub(/[^a-z0-9\s]/i, "")&.parameterize }
  has_many :seasons

  def poster
    ShowPoster.new(self)
  end
end
