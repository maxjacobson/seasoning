# Data about a particular human's relationship to a show
class MyShow < ApplicationRecord
  belongs_to :human
  belongs_to :show
  enum :status, {
    might_watch: "might_watch",
    next_up: "next_up",
    currently_watching: "currently_watching",
    stopped_watching: "stopped_watching",
    waiting_for_more: "waiting_for_more",
    finished: "finished"
  }

  def available_unwatched_content?
    unwatched_episode_badge.any_available?
  end

  def unwatched_episode_badge
    sql = ApplicationRecord.sanitize_sql_array(
      [
        <<~SQL.squish,
          select
            count(*) filter (where episodes.air_date <= :today) as available,
            count(*) filter (where episodes.air_date > :today) as upcoming
          from episodes
          join seasons on seasons.id = episodes.season_id
          left join my_seasons on my_seasons.season_id = episodes.season_id
            and my_seasons.human_id = :human_id
          where seasons.show_id = :show_id
          and (my_seasons.id is null or my_seasons.skipped = false)
          and (my_seasons.id is null
            or not (my_seasons.watched_episode_numbers @> array[episodes.episode_number]::integer[]))
        SQL
        {
          human_id: human.id,
          show_id: show.id,
          today: human.time_zone.today
        }
      ]
    )

    result = ApplicationRecord.connection.exec_query(sql, "MyShow#unwatched_episode_badge")
    available = result.first["available"].to_i
    upcoming = result.first["upcoming"].to_i
    EpisodeBadge.new(available, upcoming)
  end

  def watched_percentage
    sql = ApplicationRecord.sanitize_sql_array(
      [
        <<~SQL.squish,
          select
            case
              when total_episodes = 0 then 0.0
              else round((watched_episodes::numeric / total_episodes * 100), 1)
            end as percentage
          from (
            select
              (select count(*)
               from seasons all_seasons
               join episodes all_episodes on all_episodes.season_id = all_seasons.id
               left join my_seasons skipped_seasons on skipped_seasons.season_id = all_seasons.id
                 and skipped_seasons.human_id = :human_id
               where all_seasons.show_id = :show_id
               and (skipped_seasons.id is null or skipped_seasons.skipped = false)) as total_episodes,
              coalesce(sum(array_length(my_seasons.watched_episode_numbers, 1)), 0) as watched_episodes
            from my_seasons
            join seasons on seasons.id = my_seasons.season_id
            where seasons.show_id = :show_id
            and my_seasons.human_id = :human_id
            and my_seasons.skipped = false
          ) counts
        SQL
        {
          show_id: show.id,
          human_id: human.id
        }
      ]
    )

    result = ApplicationRecord.connection.exec_query(sql, "MyShow#watched_percentage")
    result.first["percentage"].to_f
  end

  def skipped_season?(season)
    MySeason.exists?(human: human, season: season, skipped: true)
  end
end
