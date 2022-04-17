# frozen_string_literal: true

module API
  # Your relationship to a particular season
  class YourSeasonsController < ApplicationController
    def update
      authorize! { current_human.present? }

      season = Season.find(params.require(:id))
      my_season = MySeason.create_or_find_by(human: current_human, season:)
      my_season.update!(params.require(:season).permit(:watched))

      render json: {}
    end
  end
end
