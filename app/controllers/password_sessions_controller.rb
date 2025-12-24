# Password-based login
class PasswordSessionsController < ApplicationController
  def show
    authorize! { true }

    redirect_to shows_path if current_human.present?

    @magic_link = MagicLink.new
  end

  def create
    authorize! { true }

    human = Human.find_by(email: params[:email]&.strip&.downcase)

    if human&.authenticate(params[:password])
      session[:human_id] = human.id
      redirect_to root_path, notice: "Signed in! Welcome back."
    else
      @magic_link = MagicLink.new
      flash.now[:alert] = "Invalid email or password"
      render :show, status: :unprocessable_content
    end
  end
end
