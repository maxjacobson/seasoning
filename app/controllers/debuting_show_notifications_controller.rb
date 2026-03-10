class DebutingShowNotificationsController < ApplicationController
  def destroy
    authorize! { current_human.present? }

    @notification = current_human.debuting_show_notifications.find(params[:id])
    @notification.destroy!

    redirect_back_or_to(shows_path)
  end

  def snooze
    authorize! { current_human.present? }

    @notification = current_human.debuting_show_notifications.find(params[:id])
    my_show = current_human.my_shows.find_by!(show: @notification.show)

    duration = params[:duration] == "1_month" ? 1.month : 1.week
    my_show.update!(status: "waiting_for_more", snoozed_until: duration.from_now)
    @notification.destroy!

    redirect_back_or_to(shows_path)
  end
end
