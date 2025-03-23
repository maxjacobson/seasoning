# CRUD actions for magic links
class MagicLinksController < ApplicationController
  def show
    authorize! { true }

    @magic_link = MagicLink.find_by(token: params[:token])

    if (human = @magic_link&.recipient).present?
      browser_session = human.browser_sessions.create!
      session[:token] = browser_session.token
      redirect_to root_path, notice: "Success!"
    end

    respond_to do |format|
      format.html
    end
  end

  def new
    authorize! { true }

    # FIXME: use the route helper
    redirect_to "/shows" if current_human.present?

    respond_to do |format|
      format.html
    end
  end

  def create
    authorize! { true }

    magic_link = MagicLink.new(magic_link_params)

    if magic_link.save
      magic_link.deliver
      redirect_to check_your_email_path, notice: "Success!"
    else
      flash.now[:alert] = "Bad email!"
      render :new
    end
  end

  private

  def magic_link_params
    params.expect(magic_link: [:email])
  end
end
