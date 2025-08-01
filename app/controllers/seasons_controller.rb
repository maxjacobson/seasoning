# Controller for displaying season pages
class SeasonsController < ApplicationController
  def show
    authorize! { true }

    @show = Show.find_by!(slug: params[:show_slug])
    @season = @show.seasons.find_by!(slug: params[:season_slug])
    @my_season = MySeason.find_or_initialize_by(human: current_human, season: @season)
    @episodes = @season.episodes.order(episode_number: :asc)
  end
end
