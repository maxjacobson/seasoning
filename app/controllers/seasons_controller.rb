class SeasonsController < ApplicationController
  def show
    authorize! { current_human.present? }

    @show = Show.find_by!(slug: params[:show_slug])
    @season = @show.seasons.find_by!(slug: params[:slug])
    @my_season = MySeason.find_or_initialize_by(human: current_human, season: @season)
  end
end
