class MagicLinksController < ApplicationController
  def show
    authorize! { true }

    @magic_link = MagicLink.active.find_by!(token: params[:token])
    human = Human.where(email: @magic_link.email).first

    if human.present?
      session[:human_id] = human.id
      # FIXME: add flash message
      redirect_to shows_path
    else
      @human = Human.new
    end
  end

  def create
    authorize! { true }

    magic_link = MagicLink.create!(magic_links_params)
    magic_link.deliver

    # FIXME: display flash messages
    # and add a flash message
    redirect_to root_path
  end

  private

  def magic_links_params
    params.require(:magic_link).permit(:email)
  end
end
