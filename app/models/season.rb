# A season of a TV show!
# Data is mostly from the movie database
class Season < ApplicationRecord
  belongs_to :show
  has_many :episodes, dependent: :destroy
  has_many :season_reviews, dependent: :destroy
  before_save -> { self.slug = name&.gsub(/[^a-z0-9\s]/i, "")&.parameterize }

  scope :aired_in, lambda { |year|
    where("EXTRACT(year FROM air_date) = ?", year)
  }

  def poster
    Poster.new(tmdb_poster_path.presence || show.tmdb_poster_path)
  end

  def available_episodes_count_for(human)
    sql = ApplicationRecord.sanitize_sql_array(
      [
        <<~SQL.squish,
          select
            count(*) filter (where episodes.air_date <= :today) as available,
            count(*) filter (where episodes.air_date > :today) as upcoming
          from episodes
          left join my_seasons on my_seasons.season_id = episodes.season_id
            and my_seasons.human_id = :human_id
          where episodes.season_id = :season_id
          and (my_seasons.id is null or my_seasons.skipped = false)
          and (my_seasons.id is null
            or not (my_seasons.watched_episode_numbers @> array[episodes.episode_number]::integer[]))
        SQL
        {
          human_id: human.id,
          season_id: id,
          today: human.time_zone.today
        }
      ]
    )

    result = ApplicationRecord.connection.exec_query(sql, "Season#available_episodes_count_for")
    available = result.first["available"].to_i
    upcoming = result.first["upcoming"].to_i
    EpisodeBadge.new(available, upcoming)
  end
end
