class SeasonsController < ApplicationController
  def show
    authorize! { true }

    @show = Show.find_by!(slug: params[:slug])
    @season = @show.seasons.find_by!(slug: params[:season_slug])

    @my_season = (MySeason.find_by(human: current_human, season: @season) if current_human)
  end

  def update
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:slug])
    season = show.seasons.find_by!(slug: params[:season_slug])

    my_season = MySeason.create_or_find_by(human: current_human, season: season)

    my_season.watched_episode_numbers =
      if params[:watched]
        episode = season.episodes.find_by!(episode_number: params[:watched])
        Set.new(my_season.watched_episode_numbers).add(episode.episode_number).to_a.sort
      elsif params[:unwatched]
        episode = season.episodes.find_by!(episode_number: params[:unwatched])
        Set.new(my_season.watched_episode_numbers).delete(episode.episode_number).to_a.sort
      else
        my_season.watched_episode_numbers
      end

    my_season.save!

    redirect_to season_show_path(show.slug, season.slug), notice: "Updated!"
  end
end
