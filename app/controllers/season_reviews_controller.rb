# Season review creation and management
class SeasonReviewsController < ApplicationController
  def show
    author = Human.find_by!(handle: params[:handle])
    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])
    viewing = params[:viewing]&.to_i || 1

    @review = SeasonReview.find_by!(
      author: author,
      season: season,
      viewing: viewing
    )

    authorize! { SeasonReview.viewable_by(current_human).exists?(id: @review.id) }

    @show = show
    @season = season
    @author = author
  end

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

  def edit
    authorize! { current_human.present? }

    author = Human.find_by!(handle: params[:handle])
    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])
    viewing = params[:viewing]&.to_i || 1

    @review = SeasonReview.find_by!(
      author: author,
      season: season,
      viewing: viewing
    )

    authorize! { @review.author == current_human }

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
      redirect_to proper_review_path(@review), notice: "Review created successfully"
    else
      @show = show
      @season = season
      render :new, status: :unprocessable_content
    end
  end

  def update
    authorize! { current_human.present? }

    author = Human.find_by!(handle: params[:handle])
    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])
    viewing = params[:viewing]&.to_i || 1

    @review = SeasonReview.find_by!(
      author: author,
      season: season,
      viewing: viewing
    )

    authorize! { @review.author == current_human }

    if @review.update(season_review_params)
      redirect_to proper_review_path(@review), notice: "Review updated successfully"
    else
      @show = show
      @season = season
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize! { current_human.present? }

    author = Human.find_by!(handle: params[:handle])
    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])
    viewing = params[:viewing]&.to_i || 1

    @review = SeasonReview.find_by!(
      author: author,
      season: season,
      viewing: viewing
    )

    authorize! { @review.author == current_human }

    @review.destroy!

    redirect_to season_path(show.slug, season.slug), notice: "Review deleted successfully"
  end

  private

  def season_review_params
    params.expect(season_review: [:body, :visibility, :rating])
  end
end
