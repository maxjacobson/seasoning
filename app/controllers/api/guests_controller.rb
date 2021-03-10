# frozen_string_literal: true

module API
  # Exposes some information about the current Guest of the site
  class GuestsController < ApplicationController
    def show
      guest = Guest.new

      render json: GuestSerializer.one(guest)
    end
  end
end
