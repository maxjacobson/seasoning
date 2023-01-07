# frozen_string_literal: true

module API
  # Your relationship to a particular season
  class YourSeasonsController < ApplicationController
    def update
      authorize! { current_human.present? }

      season = Season.find(params.require(:id))
      my_season = MySeason.create_or_find_by(human: current_human, season:)
      if params.require(:season).require(:watched)
        my_season.update!(
          watched_episode_numbers: season.episodes.order(episode_number: :asc).pluck(:episode_number),
          watched: true # TODO: remove me
        )
      else
        my_season.update!(
          watched_episode_numbers: [],
          watched: false # TODO: remove me
        )
      end

      render json: {}
    end
  end
end
