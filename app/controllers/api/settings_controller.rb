module API
  # The current human can look up and manipulate their settings
  class SettingsController < ApplicationController
    def show
      authorize! { current_human.present? }

      render json: SettingsSerializer.one(current_human)
    end

    def update
      authorize! { current_human.present? }

      current_human.update!(settings_params)

      render json: SettingsSerializer.one(current_human)
    end

    private

    def settings_params
      params.permit(
        :currently_watching_limit,
        :default_review_visibility,
        :share_currently_watching
      )
    end
  end
end
