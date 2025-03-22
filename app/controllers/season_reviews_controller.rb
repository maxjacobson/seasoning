# Controller for viewing season reviews
class SeasonReviewsController < ApplicationController
  def show
    @review = SeasonReview.joins(:author).joins(season: :show).where(
      author: { handle: params.require(:handle) },
      season: { slug: params.require(:season) },
      show: { slug: params.require(:show) }
    ).find_by!(viewing: params[:viewing] || 1)

    # Make sure the current human can view this review
    query = SeasonReview.viewable_by(current_human).where(id: @review.id)
    viewable = query.exists?
    
    # Debug this in the test logs
    Rails.logger.debug "REVIEW AUTHORIZATION: Review #{@review.id} viewable by #{current_human&.handle}: #{viewable}"
    Rails.logger.debug "VISIBILITY: #{@review.visibility}"
    Rails.logger.debug "QUERY: #{query.to_sql}"
    
    # Check if viewer and author are mutual followers
    if current_human && @review.author != current_human
      author_follows_viewer = Follow.exists?(follower_id: @review.author.id, followee_id: current_human.id)
      viewer_follows_author = Follow.exists?(follower_id: current_human.id, followee_id: @review.author.id)
      Rails.logger.debug "FOLLOWS: Author follows viewer: #{author_follows_viewer}, Viewer follows author: #{viewer_follows_author}"
    end

    authorize! { viewable }
  end
end