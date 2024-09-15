module API
  # Exposes up-to-the-second info on this human's show limits
  class HumanLimitsController < ApplicationController
    def show
      authorize! { current_human.present? }

      render json: HumanLimitsSerializer.one(current_human)
    end
  end
end
