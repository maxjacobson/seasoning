# frozen_string_literal: true

module API
  # Lets you search the shows so you can add some
  class ShowsController < ApplicationController
    NoShowsFound = Class.new(StandardError)

    def index
      authorize! { current_human.present? }

      query = params.require(:q)
      shows = Show.where("title ilike ?", "%#{query}%")
      render json: {
        shows: ShowSerializer.many(shows)
      }
    end

    def create
      authorize! { current_human.present? }

      response = TMDB::Client.new.search_tv(params.require(:shows).require(:query))

      raise NoShowsFound, "Not found" if response.results.none?

      tmdb_show = response.results.first
      show = FindOrCreateShow.call(tmdb_show)

      MyShow.create_or_find_by(human: current_human, show: show)

      render json: {
        show: ShowSerializer.one(show)
      }
    rescue NoShowsFound => e
      render json: {
        error: {
          message: e.message
        }
      }, status: :bad_request
    end

    def show
      authorize! { true }

      show = Show.find_by!(slug: params.fetch(:id))
      my_show = MyShow.find_or_initialize_by(human: current_human, show: show)

      render json: MyShowSerializer.one(my_show)
    end
  end
end
