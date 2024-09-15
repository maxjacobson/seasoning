module API
  # Look up info about an episode of a season
  class EpisodesController < ApplicationController
    def show
      authorize! { true }

      show = Show.find_by!(slug: params.require(:show_id))
      season = show.seasons.find_by!(slug: params.require(:season_id))
      episode = season.episodes.find_by!(episode_number: params.require(:id))

      render json: {
        show: ShowSerializer.one(show),
        season: SeasonSerializer.one(season),
        episode: EpisodeSerializer.one(episode)
      }
    end
  end
end
