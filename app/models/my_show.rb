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

  def any_new_unwatched_seasons?
    # might be nil
    most_recent_watched = MySeason
                          .joins(:season)
                          .where(
                            human:,
                            season: { show: }
                          )
                          .select(&:watched?)
                          .map { |my_season| my_season.season.season_number }
                          .max

    most_recent_released = show
                           .seasons
                           .select { |season| season.episodes.any?(&:available?) }
                           .map(&:season_number)
                           .max

    most_recent_watched.present? && most_recent_watched < most_recent_released
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
               where all_seasons.show_id = :show_id) as total_episodes,
              coalesce(sum(array_length(my_seasons.watched_episode_numbers, 1)), 0) as watched_episodes
            from my_seasons
            join seasons on seasons.id = my_seasons.season_id
            where seasons.show_id = :show_id and my_seasons.human_id = :human_id
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
end
