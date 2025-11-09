# A TV show!
# Data is mostly from the movie database
class Show < ApplicationRecord
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
  has_many :seasons, dependent: :destroy
  has_many :returning_show_notifications, dependent: :destroy

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

  def self.refresh_interval(tmdb_show)
    if tmdb_show.in_production
      # N.B. the refresh happens once per day, so this just means it'll get refreshed on the next day too
      1.hour.from_now
    else
      # N.B. don't need to refresh as often
      #
      # adding a little randomness to spread out the work over multiple days
      (5..12).to_a.sample.days.from_now
    end
  end

  def poster
    Poster.new(tmdb_poster_path)
  end

  def refresh!
    RefreshShow.call(self)
  end

  def refresh_async
    RefreshShowJob.perform_async(id)
  end

  def watchers_count
    MyShow.where(show: self).count
  end

  def skipped_seasons_for?(human)
    return false if human.nil?

    MySeason
      .joins(:season)
      .exists?(
        human: human,
        skipped: true,
        season: { show: self }
      )
  end
end
