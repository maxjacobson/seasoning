# frozen_string_literal: true

module API
  # Your relationship to a particular episode
  class YourEpisodesController < ApplicationController
    def update
      authorize! { current_human.present? }

      season = Season.find(params.require(:your_season_id))
      my_season = MySeason.create_or_find_by(human: current_human, season:)
      episode_number = params.require(:id).to_i

      my_season.watched_episode_numbers =
        if params.require(:your_episode).require(:seen)
          Set.new(my_season.watched_episode_numbers).add(episode_number).to_a.sort
        else
          Set.new(my_season.watched_episode_numbers).delete(episode_number).to_a.sort
        end

      my_season.save!

      render json: {}
    end
  end
end
