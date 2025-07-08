# Season review creation and management
class SeasonReviewsController < ApplicationController
  def new
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])

    @review = SeasonReview.new(
      author: current_human,
      season: season,
      visibility: current_human.default_review_visibility
    )
    @show = show
    @season = season
  end

  def create
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])

    @review = SeasonReview.new(
      season_review_params.merge(
        author: current_human,
        season: season,
        viewing: (SeasonReview.where(author: current_human, season: season).maximum(:viewing) || 0) + 1
      )
    )

    if @review.save
      # FIXME: Replace with proper Rails helper when season review show page is migrated to ERB
      review_path = "/#{current_human.handle}/shows/#{show.slug}/#{season.slug}"
      review_path += "/#{@review.viewing}" if @review.viewing > 1
      redirect_to review_path, notice: "Review created successfully"
    else
      @show = show
      @season = season
      render :new, status: :unprocessable_entity
    end
  end

  private

  def season_review_params
    params.expect(season_review: [:body, :visibility, :rating])
  end
end
