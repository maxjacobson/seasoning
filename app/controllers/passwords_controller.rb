# Set or change password
class PasswordsController < ApplicationController
  def edit
    authorize! { current_human.present? }
  end

  def update
    authorize! { current_human.present? }

    password_params = params.expect(human: [:password, :password_confirmation])

    if current_human.update(password_params)
      redirect_to settings_path, notice: "Password saved!"
    else
      render :edit, status: :unprocessable_content
    end
  end
end
