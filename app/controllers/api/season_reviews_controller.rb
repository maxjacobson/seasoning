# frozen_string_literal: true

module API
  # People can review seasons of shows
  class SeasonReviewsController < ApplicationController
    def create
      authorize! { current_human.present? }

      show = Show.find(params.require(:show_id))
      season = show.seasons.find(params.require(:season_id))

      existing_review_count = SeasonReview.where(
        author: current_human,
        season: season
      ).count

      review = SeasonReview.new(
        season_review_params.merge(
          author: current_human,
          season: season,
          viewing: existing_review_count + 1
        )
      )

      if review.save
        render json: {
          review: SeasonReviewSerializer.one(review)
        }
      else
        render json: review.errors, status: :bad_request
      end
    end

    def show
      review = SeasonReview.joins(:author).joins(season: :show).where(
        author: { handle: params.require(:handle) },
        season: { slug: params.require(:season) },
        show: { slug: params.require(:show) }
      ).find_by!(viewing: params[:viewing] || 1)

      authorize! { review.viewable_by?(current_human) }

      render json: {
        show: ShowSerializer.one(review.season.show),
        season: SeasonSerializer.one(review.season),
        review: SeasonReviewSerializer.one(review)
      }
    end

    def index
      authorize! { true }

      reviews = SeasonReview.order(created_at: :desc).lazy.select do |review|
        review.viewable_by?(current_human)
      end

      render json: {
        data: reviews.map do |review|
          {
            show: ShowSerializer.one(review.season.show),
            review: SeasonReviewSerializer.one(review)
          }
        end
      }
    end

    private

    def season_review_params
      params.require(:review).permit(:body, :visibility, :spoilers, :rating)
    end
  end
end
