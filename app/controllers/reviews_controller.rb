# Exposes a profile's reviews
class ReviewsController < ApplicationController
  def index
    authorize! { true }

    @profile = Human.find_by!(handle: params[:handle])

    @reviews = SeasonReview
               .where(author: @profile)
               .viewable_by(current_human)
               .limit(30)
               .order(created_at: :desc)
  end
end
