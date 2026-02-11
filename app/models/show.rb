# A TV show!
# Data is mostly from the movie database
class Show < ApplicationRecord
  before_save :set_sort_by_title, if: :title_changed?

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
    order(:sort_by_title)
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

  def self.find_or_create_from_tmdb(tmdb_show)
    show = find_by(tmdb_tv_id: tmdb_show.id)
    show ||= create!(
      first_air_date: tmdb_show.first_air_date,
      title: tmdb_show.name,
      tmdb_tv_id: tmdb_show.id,
      tmdb_poster_path: tmdb_show.poster_path,
      tmdb_next_refresh_at: refresh_interval(tmdb_show),
      tmdb_last_refreshed_at: Time.zone.now
    )

    TMDB::Client.new.tv_details(show.tmdb_tv_id).seasons.each do |tmdb_season|
      next if show.seasons.exists?(season_number: tmdb_season.season_number)
      next if tmdb_season.season_number.zero?
      next if tmdb_season.episode_count.zero?
      next if tmdb_season.air_date.nil?

      season = show.seasons.create(
        tmdb_id: tmdb_season.id,
        name: tmdb_season.name,
        season_number: tmdb_season.season_number,
        episode_count: tmdb_season.episode_count,
        tmdb_poster_path: tmdb_season.poster_path,
        air_date: tmdb_season.air_date
      )

      season.refresh_episodes!
    end

    show
  end

  def refresh!
    begin
      details = TMDB::Client.new.tv_details(tmdb_tv_id)
    rescue TMDB::Client::NotFound
      update!(orphaned: true)
      return
    end

    self.class.transaction do
      update!(
        tmdb_poster_path: details.poster_path,
        tmdb_next_refresh_at: self.class.refresh_interval(details),
        first_air_date: details.first_air_date,
        tmdb_last_refreshed_at: Time.zone.now,
        orphaned: false
      )

      seen_season_ids = []

      details.seasons.each do |tmdb_season|
        next if tmdb_season.season_number.zero?
        next if tmdb_season.episode_count.zero?
        next if tmdb_season.air_date.nil?

        season = seasons.find_by(season_number: tmdb_season.season_number)
        if season.present?
          season.update!(
            name: tmdb_season.name,
            episode_count: tmdb_season.episode_count,
            tmdb_id: tmdb_season.id,
            tmdb_poster_path: tmdb_season.poster_path,
            air_date: tmdb_season.air_date,
            orphaned: false
          )
        else
          season = seasons.create!(
            tmdb_id: tmdb_season.id,
            name: tmdb_season.name,
            season_number: tmdb_season.season_number,
            episode_count: tmdb_season.episode_count,
            tmdb_poster_path: tmdb_season.poster_path,
            air_date: tmdb_season.air_date
          )
        end
        seen_season_ids << season.id
        season.refresh_episodes!
      end

      seasons.where.not(id: seen_season_ids).find_each do |season|
        season.update!(orphaned: true)
      end
    end
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

  private

  def set_sort_by_title
    self.sort_by_title = title&.gsub(/\A(the|a|an)\s+/i, "")
  end
end
