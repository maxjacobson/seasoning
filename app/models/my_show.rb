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
    result = ApplicationRecord.connection.exec_query(<<~SQL.squish, "MyShow#watched_percentage", [show.id, human.id])
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
           where all_seasons.show_id = $1 and all_episodes.air_date <= current_date) as total_episodes,
          coalesce(sum(array_length(my_seasons.watched_episode_numbers, 1)), 0) as watched_episodes
        from my_seasons
        join seasons on seasons.id = my_seasons.season_id
        where seasons.show_id = $1 and my_seasons.human_id = $2
      ) counts
    SQL

    result.first["percentage"].to_f
  end

  def aired_episodes?
    show.first_air_date.present? && show.first_air_date <= Time.zone.today
  end
end
