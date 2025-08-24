class StatsController < ApplicationController
  def index
    authorize! { current_human&.handle == params[:handle] }

    redirect_to profile_stat_path(handle: params[:handle], year: Date.current.year)
  end

  def show
    authorize! { current_human&.handle == params[:handle] }

    @human = Human.find_by!(handle: params[:handle])
    @year = params[:year].to_i

    raise ActionController::RoutingError, "Not Found" if @year > Date.current.year

    @reviews = SeasonReview
               .authored_by(@human)
               .written_in(@year)
               .viewable_by(current_human)
               .includes(season: :show)

    @previous_year = @year - 1
    @next_year = @year + 1
    @has_next_year = @next_year <= Date.current.year
  end
end
