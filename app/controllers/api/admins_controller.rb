# frozen_string_literal: true

module API
  # Exposes some data for the admin page
  class AdminsController < ApplicationController
    def show
      authorize! { current_human&.admin? }

      render json: {
        humansCount: Human.count,
        showsCount: Show.count,
        seasonsCount: Season.count,
        reviewsCount: SeasonReview.count,
        lastRefreshedTmdbConfigAt: TMDBAPIConfiguration.only.fetched_at,
        recentHumans: HumanSerializer.many(Human.order(created_at: :desc).limit(10))
      }
    end
  end
end
