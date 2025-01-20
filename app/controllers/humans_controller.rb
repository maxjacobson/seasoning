class HumansController < ApplicationController
  def create
    magic_link = MagicLink.find_by(token: params[:magic_link_token])

    authorize! { magic_link.present? }

    human = Human.create!(
      human_params.merge(
        email: magic_link.email
      )
    )
    session[:human_id] = human.id
    redirect_to shows_path
  end

  private

  def human_params
    params.require(:human).permit(:handle)
  end
end
