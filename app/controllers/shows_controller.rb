# Lists/filters the shows a human has added
class ShowsController < ApplicationController
  PAGE_SIZE = 30

  def index
    authorize! { current_human.present? }

    @filters = MyShowFilters.new(params.permit(:q, statuses: []).merge(page: current_page))

    @my_shows = current_human
                .my_shows
                .joins(:show)
                .then { |relation| search(relation, @filters) }
                .order(
                  Arel.sql(
                    <<~SQL.squish
                      status asc,
                      regexp_replace(title, '^(The|A)\s', '', 'i')
                    SQL
                  )
                )
                .limit(PAGE_SIZE + 1) # Get one extra to check if there's a next page
                .offset((current_page - 1) * PAGE_SIZE)

    @has_next_page = @my_shows.size > PAGE_SIZE
    @my_shows = @my_shows.limit(PAGE_SIZE) if @has_next_page
    @has_previous_page = current_page > 1
  end

  def show
    authorize! { true }

    @show = Show.find_by!(slug: params[:slug])

    @my_show = (current_human.my_shows.find_by(show: @show) if current_human.present?)
  end

  private

  def search(my_shows, filters)
    my_shows = my_shows.where(status: filters.statuses) if filters.statuses.present?

    if filters.q.present?
      my_shows.where(
        <<~SQL.squish,
          (shows.title ilike :query) or (my_shows.note_to_self ilike :query)
        SQL
        query: "%#{filters.q}%"
      )
    else
      my_shows
    end
  end
end
