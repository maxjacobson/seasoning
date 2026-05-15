class SeasonReviewLikesController < ApplicationController
  def create
    authorize! { current_human.present? }

    review = SeasonReview.find(params[:season_review_id])
    SeasonReviewLike.create_or_find_by!(human: current_human, season_review: review)

    redirect_to proper_review_path(review), notice: "Liked!"
  end

  def destroy
    authorize! { current_human.present? }

    like = SeasonReviewLike.find_by!(id: params[:id], human: current_human)

    like.destroy!
    redirect_to proper_review_path(like.season_review), notice: "Unliked!"
  end
end
