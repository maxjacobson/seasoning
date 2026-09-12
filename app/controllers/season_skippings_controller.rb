# Controller for marking seasons as skipped or not skipped
class SeasonSkippingsController < ApplicationController
  def create
    require_authentication!
    authorize! { true }

    show = Show.find_by!(slug: params.expect(:show_slug))
    season = show.seasons.find_by!(slug: params.expect(:season_slug))

    my_season = MySeason.create_or_find_by!(human: current_human, season: season)
    my_season.update!(skipped: true)

    redirect_back_or_to season_path(show.slug, season.slug), notice: "#{season.name} marked as skipped"
  end

  def destroy
    require_authentication!
    authorize! { true }

    show = Show.find_by!(slug: params.expect(:show_slug))
    season = show.seasons.find_by!(slug: params.expect(:season_slug))

    my_season = MySeason.create_or_find_by!(human: current_human, season: season)
    my_season.update!(skipped: false)

    redirect_back_or_to season_path(show.slug, season.slug), notice: "#{season.name} unmarked as skipped"
  end
end
