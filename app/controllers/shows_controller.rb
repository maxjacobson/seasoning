# Lists/filters the shows a human has added
class ShowsController < ApplicationController
  PAGE_SIZE = 10

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
                .limit(PAGE_SIZE)
                .offset((current_page - 1) * PAGE_SIZE)
  end

  private

  def search(my_shows, filters)
    my_shows = my_shows.where(status: filters.statuses) if filters.statuses.present?

    if filters.q.present?
      my_shows.where("shows.title ilike ?", "%#{filters.q}%")
    else
      my_shows
    end
  end
end
