# Exposes a profile's reviews
class ReviewsController < ApplicationController
  PER_PAGE = 30

  def index
    authorize! { true }

    @profile = Human.find_by!(handle: params[:handle])
    @page = current_page
    offset = (@page - 1) * PER_PAGE

    @reviews = SeasonReview
               .where(author: @profile)
               .viewable_by(current_human)
               .limit(PER_PAGE + 1) # Get one extra to check if there's a next page
               .offset(offset)
               .order(created_at: :desc)

    @has_next_page = @reviews.size > PER_PAGE
    @reviews = @reviews.limit(PER_PAGE) if @has_next_page
    @has_previous_page = @page > 1
  end
end
