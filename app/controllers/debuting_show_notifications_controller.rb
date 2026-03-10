class DebutingShowNotificationsController < ApplicationController
  def destroy
    authorize! { current_human.present? }

    @notification = current_human.debuting_show_notifications.find(params[:id])
    @notification.destroy!

    redirect_back_or_to(shows_path)
  end
end
