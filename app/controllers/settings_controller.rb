# Human settings
class SettingsController < ApplicationController
  def show
    require_authentication!
    authorize! { true }
  end

  def update
    require_authentication!
    authorize! { true }

    current_human.update!(
      params.expect(human: [:default_review_visibility, :currently_watching_limit, :share_currently_watching,
                            :time_zone_name])
    )

    redirect_to settings_path, notice: "Saved!"
  end
end
