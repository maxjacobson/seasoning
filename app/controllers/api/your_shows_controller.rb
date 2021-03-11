# frozen_string_literal: true

module API
  # Exposes all of the current human's shows -- ones that they have saved
  class YourShowsController < ApplicationController
    def index
      authorize! { current_human.present? }

      render json: {
        shows: ShowSerializer.many(current_human.shows)
      }
    end
  end
end
