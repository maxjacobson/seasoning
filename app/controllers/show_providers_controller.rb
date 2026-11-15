# Shows where a show can be watched
class ShowProvidersController < ApplicationController
  def show
    require_authentication!
    authorize! { true } # any authenticated human can see where a show can be watched

    @show = Show.find_by!(slug: params.expect(:show_slug))
    show_providers = @show.show_providers.includes(:provider).order(:display_priority)
    @preferences = current_human.provider_preferences.index_by(&:provider_id)
    @include_hidden = params[:all] == "1"
    @show_providers =
      if @include_hidden
        show_providers
      else
        show_providers.reject { |show_provider| @preferences[show_provider.provider_id]&.hidden? }
      end
    @hidden_count = show_providers.length - @show_providers.length
  end
end
