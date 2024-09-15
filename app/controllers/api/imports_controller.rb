module API
  # lets people add new shows to the site that the site isn't yet aware of
  class ImportsController < ApplicationController
    def index
      authorize! { current_human.present? }

      response = TMDB::Client.new.search_tv(params.require(:query))

      render json: {
        shows: ImportSerializer.many(response.results)
      }
    end

    def create
      authorize! { current_human.present? }

      tmdb_show = TMDB::Client.new.tv_details(params.require(:imports).require(:id))

      show = FindOrCreateShow.call(tmdb_show)

      MyShow.create_or_find_by(human: current_human, show:)

      render json: {
        show: ShowSerializer.one(show)
      }
    end
  end
end
