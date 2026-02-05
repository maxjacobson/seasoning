# Controller for displaying season pages
class SeasonsController < ApplicationController
  def show
    authorize! { true }

    @show = Show.find_by!(slug: params[:show_slug])
    @season = @show.seasons.find_by!(slug: params[:season_slug])
    @my_season = MySeason.find_or_initialize_by(human: current_human, season: @season)
    @episodes = @season.episodes.order(episode_number: :asc)
    @season_reviews = @season.season_reviews.viewable_by(current_human)
                             .includes(:author)
                             .order(created_at: :desc)
  end

  def destroy
    authorize! { current_human&.admin? }

    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])

    unless season.orphaned?
      redirect_to season_path(show.slug, season.slug), alert: "Only orphaned seasons can be deleted"
      return
    end

    if season.season_reviews.any?
      redirect_to season_path(show.slug, season.slug), alert: "Cannot delete a season that has reviews"
      return
    end

    season.destroy!
    redirect_to show_path(show.slug), notice: "Deleted #{season.name}"
  end
end
