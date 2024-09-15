module API
  # Access the set of reviews for a particular person on the site
  class ProfileSeasonReviewsController < ApplicationController
    def index
      authorize! { true }

      profile = Human.find_by!(handle: params.require(:profile_id))

      reviews = SeasonReview
                .where(author: profile)
                .viewable_by(current_human)
                .limit(10)
                .order(created_at: :desc)

      render json: {
        reviews: reviews.map do |review|
          {
            review: SeasonReviewSerializer.one(review),
            show: ShowSerializer.one(review.season.show)
          }
        end
      }
    end
  end
end
