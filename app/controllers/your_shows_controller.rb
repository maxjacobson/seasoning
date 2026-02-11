# actions for a human to manage their relationship to a show
class YourShowsController < ApplicationController
  def create
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:show_slug])

    MyShow.create_or_find_by(human: current_human, show:)
    redirect_to show_path(show.slug), notice: "Added #{show.title}"
  end

  def update
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:show_slug])
    my_show = current_human.my_shows.find_by!(show: show)

    my_show.update!(params.expect(my_show: [:status, :note_to_self]))

    redirect_to show_path(show.slug), notice: "Updated #{show.title}"
  end

  def destroy
    authorize! { current_human.present? }

    show = Show.find_by!(slug: params[:show_slug])
    MyShow.remove!(show:, human: current_human)
    redirect_to show_path(show.slug), notice: "Removed #{show.title}"
  end
end
