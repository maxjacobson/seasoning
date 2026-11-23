# Deleting humans is an admin-only action, reachable from the admin page
module Admins
  class HumansController < ApplicationController
    def destroy
      require_authentication!
      authorize! { current_human.admin? }

      human = Human.find(params.expect(:id))

      if human == current_human
        redirect_to admin_path, alert: "You cannot delete yourself"
      elsif human.added_shows?
        redirect_to admin_path, alert: "#{human.handle} has added shows, so they cannot be deleted"
      else
        human.destroy!
        redirect_to admin_path, notice: "Deleted #{human.handle}"
      end
    end
  end
end
