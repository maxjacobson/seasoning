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

    @filter = params[:filter]

    # Redirect to default filter if none specified
    if @filter.blank?
      redirect_to profile_stat_path(params[:handle], params[:year], filter: "reviewed-in")
      return
    end

    # Validate filter parameter
    unless ["reviewed-in", "aired-in"].include?(@filter)
      redirect_to profile_stat_path(params[:handle], params[:year], filter: "reviewed-in")
      return
    end

    @reviews = if @filter == "reviewed-in"
                 SeasonReview
                   .authored_by(@human)
                   .written_in(@year)
                   .viewable_by(current_human)
                   .includes(season: :show)
               else # aired-in
                 SeasonReview
                   .authored_by(@human)
                   .joins(:season)
                   .merge(Season.aired_in(@year))
                   .viewable_by(current_human)
                   .includes(season: :show)
               end

    @previous_year = @year - 1
    @next_year = @year + 1
    @has_next_year = @next_year <= Date.current.year
  end
end
