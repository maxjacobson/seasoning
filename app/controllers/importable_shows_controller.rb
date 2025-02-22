# Lets people import new shows into the application
class ImportableShowsController < ApplicationController
  def index
    authorize! { current_human.present? }

    @results = TMDB::Client.new.search_tv(params.require(:q)).results.map { ImportableShow.new(it) }
  end

  def create
    authorize! { current_human.present? }

    tmdb_show = TMDB::Client.new.tv_details(params.require(:id))

    show = FindOrCreateShow.call(tmdb_show)

    MyShow.create_or_find_by(human: current_human, show:)

    # FIXME: use the nice helper method
    redirect_to "/shows/#{show.slug}", notice: "Success!"
  end
end
