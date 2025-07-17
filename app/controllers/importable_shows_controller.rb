# Lets people import new shows into the application
class ImportableShowsController < ApplicationController
  def create
    authorize! { current_human.present? }

    tmdb_show = TMDB::Client.new.tv_details(params.require(:id))

    show = FindOrCreateShow.call(tmdb_show)

    MyShow.create_or_find_by(human: current_human, show:)

    redirect_to show_path(show.slug), notice: "You've imported #{show.title}! Thanks."
  end
end
