# Controller for displaying individual episode pages
class EpisodesController < ApplicationController
  def show
    authorize! { true }

    @show = Show.find_by!(slug: params[:show_slug])
    @season = @show.seasons.find_by!(slug: params[:season_slug])
    @episode = @season.episodes.find_by!(episode_number: params[:episode_number])
  end
end
