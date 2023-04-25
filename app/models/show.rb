# frozen_string_literal: true

# A TV show!
# Data is mostly from the movie database
class Show < ApplicationRecord
  REFRESH_INTERVAL = 2.days

  before_create lambda {
    slug = nil
    n = nil
    loop do
      slug = title&.gsub(/[^a-z0-9\s]/i, "")&.parameterize
      slug = "#{slug}-#{n}" if n && slug

      break unless Show.exists?(slug:)

      n ||= 0
      n += 1
    end

    self.slug = slug
  }
  has_many :seasons

  scope :needs_refreshing, lambda {
    where(tmdb_next_refresh_at: nil).or(where(tmdb_next_refresh_at: ..(Time.zone.now)))
  }

  scope :alphabetical, lambda {
    order(
      Arel.sql(
        <<~SQL.squish
          regexp_replace(title, '^(The|A)\s', '', 'i')
        SQL
      )
    )
  }

  def poster
    Poster.new(tmdb_poster_path)
  end

  def refresh!
    RefreshShow.call(self)
  end

  def refresh_async
    RefreshShowJob.perform_async(id)
  end
end
