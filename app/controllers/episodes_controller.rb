# Controller for displaying individual episode pages
class EpisodesController < ApplicationController
  def show
    authorize! { current_human.present? }

    @show = Show.find_by!(slug: params.expect(:show_slug))
    @season = @show.seasons.find_by!(slug: params.expect(:season_slug))
    @episode = @season.episodes.find_by!(episode_number: params.expect(:episode_number))
    @my_show = current_human.my_shows.find_by(show: @show)
    @my_season = MySeason.find_by(human: current_human, season: @season)
  end
end
