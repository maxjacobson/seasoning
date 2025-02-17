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

    browser_session = human.browser_sessions.create!

    session[:token] = browser_session.token
    redirect_to root_path, notice: "Success!"
  end
end
