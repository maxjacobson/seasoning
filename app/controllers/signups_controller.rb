# Sign up page
class SignupsController < ApplicationController
  def show
    authorize! { true }

    redirect_to shows_path if current_human.present?

    @magic_link = MagicLink.new
  end

  def create
    authorize! { true }

    @magic_link = MagicLink.new(magic_link_params)

    if @magic_link.save
      @magic_link.deliver
      redirect_to check_your_email_path, notice: "Sent! Check your email."
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def magic_link_params
    params.expect(magic_link: [:email])
  end
end
