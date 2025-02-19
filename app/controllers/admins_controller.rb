# Some stats for admins to look at
class AdminsController < ApplicationController
  def show
    authorize! { current_human&.admin? }
  end
end
