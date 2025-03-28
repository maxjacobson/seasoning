# Lets ya sign out
class SessionsController < ApplicationController
  def destroy
    authorize! { true }
    session.clear
    redirect_to root_path, notice: "Signed out! Come back soon."
  end
end
