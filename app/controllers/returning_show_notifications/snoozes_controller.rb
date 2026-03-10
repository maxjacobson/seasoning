module ReturningShowNotifications
  class SnoozesController < ApplicationController
    def create
      authorize! { current_human.present? }

      notification = current_human.returning_show_notifications.find(params[:returning_show_notification_id])
      my_show = current_human.my_shows.find_by!(show: notification.show)

      duration = params[:duration] == "1_month" ? 1.month : 1.week
      my_show.update!(status: "waiting_for_more", snoozed_until: duration.from_now)
      notification.destroy!

      redirect_back_or_to(shows_path)
    end
  end
end
