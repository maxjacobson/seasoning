module API
  # Look up info about a season of a show
  class SeasonsController < ApplicationController
    def show
      authorize! { true }

      show = Show.find_by!(slug: params.require(:show_id))
      season = show.seasons.find_by!(slug: params.require(:id))

      my_season = MySeason.find_or_initialize_by(human: current_human, season:)

      render json: MySeasonSerializer.one(my_season)
    end
  end
end
