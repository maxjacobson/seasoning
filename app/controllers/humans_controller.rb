# CRUD actions for humans
class HumansController < ApplicationController
  def create
    authorize! { true }

    human_params = params.expect(human: [:magic_link_token, :handle, :password, :password_confirmation])
    magic_link = MagicLink.active.find_by!(token: human_params[:magic_link_token])

    human = Human.new(
      email: magic_link.email,
      handle: human_params[:handle],
      password: human_params[:password],
      password_confirmation: human_params[:password_confirmation]
    )

    if human.save
      session[:human_id] = human.id
      redirect_to root_path, notice: "Signed up! Welcome."
    else
      @magic_link = magic_link
      @human = human
      render "magic_links/show", status: :unprocessable_content
    end
  end
end
