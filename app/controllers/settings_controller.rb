# Human settings
class SettingsController < ApplicationController
  def show
    authorize! { current_human.present? }
  end

  def update
    authorize! { current_human.present? }

    current_human.update!(
      params.expect(human: [:default_review_visibility, :currently_watching_limit, :share_currently_watching,
                            :time_zone_name])
    )

    redirect_to settings_path, notice: "Saved!"
  end
end
