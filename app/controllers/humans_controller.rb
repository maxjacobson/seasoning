# CRUD actions for humans
class HumansController < ApplicationController
  def create
    authorize! { true }

    human_params = params.expect(human: [:magic_link_token, :handle])
    magic_link = MagicLink.active.find_by!(token: human_params[:magic_link_token])

    human = Human.create!(
      email: magic_link.email,
      handle: human_params[:handle]
    )

    session[:human_id] = human.id
    redirect_to root_path, notice: "Signed up! Welcome."
  end
end
