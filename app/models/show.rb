# frozen_string_literal: true

# A TV show!
# Data is mostly from the movie database
class Show < ApplicationRecord
  REFRESH_INTERVAL = 2.weeks

  before_create -> { self.slug = title&.gsub(/[^a-z0-9\s]/i, "")&.parameterize }
  has_many :seasons

  scope :needs_refreshing, lambda {
    where(tmdb_next_refresh_at: nil).or(where(tmdb_next_refresh_at: ..(Time.zone.now)))
  }

  def poster
    Poster.new(tmdb_poster_path)
  end

  def refresh!
    RefreshShow.call(self)
  end
end
