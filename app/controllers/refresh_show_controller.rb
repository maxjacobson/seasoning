# A way to let me force a refresh just to see if something weird is going on
class RefreshShowController < ApplicationController
  def create
    authorize! { current_human&.admin? }

    show = Show.find_by!(slug: params[:show_slug])
    show.refresh!

    redirect_to show_path(show.slug), notice: "Refreshed #{show.title}"
  end
end
