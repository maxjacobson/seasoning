module DebutingShowNotifications
  class WatchingsController < ApplicationController
    def create
      require_authentication!
      authorize! { true }

      notification = current_human.debuting_show_notifications.find(params.expect(:debuting_show_notification_id))
      my_show = current_human.my_shows.find_by!(show: notification.show)

      my_show.update!(status: "currently_watching")
      notification.destroy!

      redirect_to show_path(notification.show.slug), notice: "Updated #{notification.show.title}"
    end
  end
end
