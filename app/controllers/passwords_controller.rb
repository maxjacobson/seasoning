# Set or change password
class PasswordsController < ApplicationController
  def edit
    require_authentication!
    authorize! { true }
  end

  def update
    require_authentication!
    authorize! { true }

    password_params = params.expect(human: [:password, :password_confirmation])

    if current_human.update(password_params)
      redirect_to settings_path, notice: "Password saved!"
    else
      render :edit, status: :unprocessable_content
    end
  end
end
