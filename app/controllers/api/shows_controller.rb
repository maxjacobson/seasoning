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
  end
end
