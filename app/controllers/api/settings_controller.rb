# frozen_string_literal: true

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
      params.permit(:share_currently_watching, :default_review_visibility)
    end
  end
end
