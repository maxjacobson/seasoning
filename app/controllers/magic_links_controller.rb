# CRUD actions for magic links
class MagicLinksController < ApplicationController
  def show
    authorize! { true }

    @magic_link = MagicLink.find_by(token: params[:token])

    if (human = @magic_link&.recipient).present?
      session[:human_id] = human.id
      redirect_to root_path, notice: "Signed in! Welcome back."
    end

    @human = Human.new(email: @magic_link&.email) if @magic_link

    respond_to do |format|
      format.html
    end
  end

  def new
    authorize! { true }

    redirect_to shows_path if current_human.present?

    @magic_link = MagicLink.new

    respond_to do |format|
      format.html
    end
  end

  def create
    authorize! { true }

    @magic_link = MagicLink.new(magic_link_params)

    if @magic_link.save
      @magic_link.deliver
      redirect_to check_your_email_path, notice: "Sent! Check your email."
    else
      render "password_sessions/show", status: :unprocessable_content
    end
  end

  private

  def magic_link_params
    params.expect(magic_link: [:email])
  end
end
