class EpisodesController < ApplicationController
  def show
    authorize! { true }
    @show = Show.find_by!(slug: params[:slug])
    @season = @show.seasons.find_by!(slug: params[:season_slug])
    @episode = @season.episodes.find_by!(params[:episode_number])
  end
end
