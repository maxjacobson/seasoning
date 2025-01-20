class SessionsController < ApplicationController
  def destroy
    authorize! { true }

    session.clear
    # FIXME: add notice
    redirect_to root_path
  end
end
