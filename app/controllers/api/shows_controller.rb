# frozen_string_literal: true

module API
  # Lets you search the shows so you can add some
  class ShowsController < ApplicationController
    NoShowsFound = Class.new(StandardError)

    def index
      authorize! { current_human.present? }

      query = params.require(:q)
      persisted_shows = Show.where("title ilike ?", "%#{query}%").map do |show|
        {
          title: show.title,
          slug: show.slug,
          imported: true
        }
      end

      searched_shows = TMDB::Client.new.search_tv(query).results.map do |show|
        next if show.first_air_date.blank?
        next if Show.exists?(tmdb_tv_id: show.id)

        {
          title: [
            show.name,
            "(#{Date.parse(show.first_air_date).year})"
          ].join(" "),
          imported: false,
          tmdb_id: show.id
        }
      end.compact

      render json: {
        shows: persisted_shows + searched_shows
      }
    end

    def create
      authorize! { current_human.present? }

      tmdb_show = TMDB::Client.new.tv_details(params.require(:shows).require(:tmdb_id))

      show = FindOrCreateShow.call(tmdb_show)

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
