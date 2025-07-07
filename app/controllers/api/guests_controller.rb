module API
  # Exposes some information about the current Guest of the site
  class GuestsController < ApplicationController
    def show
      authorize! { true }
      guest = Guest.from(current_human)

      render json: GuestSerializer.one(guest)
    end
  end
end
