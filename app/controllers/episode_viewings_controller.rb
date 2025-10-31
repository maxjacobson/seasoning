# Controller for marking episodes as seen or not seen
class EpisodeViewingsController < ApplicationController
  def create
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])
    episode = season.episodes.find_by!(episode_number: params[:episode_number])

    my_season = MySeason.create_or_find_by!(human: current_human, season: season)
    my_season.watched_episode_numbers =
      Set.new(my_season.watched_episode_numbers).add(episode.episode_number).to_a.sort
    my_season.save!

    redirect_back_or_to season_path(show.slug, season.slug), notice: "#{episode.name} marked as seen"
  end

  def destroy
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:show_slug])
    season = show.seasons.find_by!(slug: params[:season_slug])
    episode = season.episodes.find_by!(episode_number: params[:episode_number])

    my_season = MySeason.create_or_find_by!(human: current_human, season: season)
    my_season.watched_episode_numbers =
      Set.new(my_season.watched_episode_numbers).delete(episode.episode_number).to_a.sort
    my_season.save!

    redirect_back_or_to season_path(show.slug, season.slug), notice: "#{episode.name} marked as not seen"
  end
end
