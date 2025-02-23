module API
  # The current human can look up and manipulate their settings
  class SettingsController < ApplicationController
    def show
      authorize! { current_human.present? }

      render json: SettingsSerializer.one(current_human)
    end
  end
end
