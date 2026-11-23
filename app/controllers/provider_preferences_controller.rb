# CRUD actions for a human's preferences about watch providers (pinning and hiding)
class ProviderPreferencesController < ApplicationController
  def create
    require_authentication!
    authorize! { true } # any authenticated human can pin or hide providers

    provider = Provider.find(params.expect(:provider_id))
    status = params.expect(:status)

    if ProviderPreference::STATUSES.include?(status)
      ProviderPreference.find_or_initialize_by(human: current_human, provider: provider).update!(status: status)

      notice = status == "pinned" ? "Pinned!" : "Hidden!"
      redirect_back_or_to settings_path, notice: notice
    else
      head :bad_request
    end
  end

  def destroy
    require_authentication!
    authorize! { true } # any authenticated human can unpin or unhide providers

    provider = Provider.find(params.expect(:provider_id))
    preference = ProviderPreference.find_by!(human: current_human, provider: provider)
    notice = preference.pinned? ? "Unpinned!" : "Unhidden!"
    preference.destroy

    redirect_back_or_to settings_path, notice: notice
  end
end
