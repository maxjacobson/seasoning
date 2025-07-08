module API
  # People can review seasons of shows
  class SeasonReviewsController < ApplicationController
    def show
      review = SeasonReview.joins(:author).joins(season: :show).where(
        author: { handle: params.require(:handle) },
        season: { slug: params.require(:season) },
        show: { slug: params.require(:show) }
      ).find_by!(viewing: params[:viewing] || 1)

      authorize! { SeasonReview.viewable_by(current_human).exists?(id: review.id) }

      render json: {
        show: ShowSerializer.one(review.season.show),
        season: SeasonSerializer.one(review.season),
        review: SeasonReviewSerializer.one(review),
        author: HumanSerializer.one(review.author)
      }
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
  end
end
