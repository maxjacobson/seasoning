# frozen_string_literal: true

module API
  # Lets you search the shows so you can add some
  class ShowsController < ApplicationController
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

      wikipedia_page = Wikipedia::TVShowPage.new(params.require(:shows).require(:wikipedia_url))
      show = Show.find_by(title: wikipedia_page.title)
      show ||= Show.create!(
        title: wikipedia_page.title,
        wikipedia_page_id: wikipedia_page.page_id,
        number_of_seasons: wikipedia_page.number_of_seasons
      )

      render json: {
        show: ShowSerializer.one(show)
      }
    rescue Wikipedia::WikipediaError => e
      render json: {
        error: {
          message: e.message
        }
      }, status: 400
    end

    def show
      authorize! { true }

      show = Show.find_by!(slug: params.fetch(:id))
      my_show = MyShow.find_or_initialize_by(human: current_human, show: show)

      render json: MyShowSerializer.one(my_show)
    end
  end
end
