class ShowsController < ApplicationController
  PAGE_SIZE = 10


  def index
    authorize! { current_human.present? }
    @my_shows = current_human
                .my_shows
                .joins(:show)
                .then { |relation| search(relation) }
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


  def show
    authorize! { current_human.present? }

    @show = Show.find_by!(slug: params[:slug])
  end

  private

  def current_page
    Integer(params[:page]).tap do |val|
      raise ArgumentError unless val >= 1
    end
  rescue TypeError, ArgumentError
    1
  end

  def search(my_shows)
    my_shows = my_shows.where(status: params[:statuses]) if params[:statuses].is_a?(Array)

    if params[:q].present?
      my_shows.where("shows.title ilike ?", "%#{params[:q]}%")
    else
      my_shows
    end
  end
end
