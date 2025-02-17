# A page where we can tell the user to go check their email to proceed
# with the magic link sign in flow
class CheckYourEmailController < ApplicationController
  def show
    authorize! { true }
  end
end
