# Boots up the react app, which handles routing on the client side
class FrontendController < ApplicationController
  def show
    authorize! { true }

    respond_to do |format|
      format.html
    end
  end
end
