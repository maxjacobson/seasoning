# Some stats for admins to look at
class AdminsController < ApplicationController
  def show
    require_authentication!
    authorize! { current_human.admin? }
  end
end
