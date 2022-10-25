# frozen_string_literal: true

module API
  # People can review seasons of shows
  class SeasonReviewsController < ApplicationController
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
        review: SeasonReviewSerializer.one(review),
        author: HumanSerializer.one(review.author)
      }
    end

    def create
      authorize! { current_human.present? }

      show = Show.find(params.require(:show_id))
      season = show.seasons.find(params.require(:season_id))

      review = SeasonReview.new(
        season_review_params.merge(
          author: current_human,
          season:,
          viewing: (SeasonReview.where(author: current_human, season:).maximum(:viewing) || 0) + 1
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

    def destroy
      review_to_destroy = SeasonReview.joins(:author).joins(season: :show).where(
        author: { handle: params.require(:handle) },
        season: { slug: params.require(:season) },
        show: { slug: params.require(:show) }
      ).find_by!(viewing: params[:viewing] || 1)

      authorize! { review_to_destroy.author == current_human }

      review_to_destroy.destroy!

      render json: {}
    end

    private

    def season_review_params
      params.require(:review).permit(:body, :visibility, :rating)
    end
  end
end
