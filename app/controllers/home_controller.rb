class HomeController < ApplicationController
  def show
    authorize! { true }

    if current_human.present?
      redirect_to shows_path
    else
      @magic_link = MagicLink.new
    end
  end
end
