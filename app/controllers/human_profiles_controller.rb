# Someone's profile page
class HumanProfilesController < ApplicationController
  def show
    authorize! { true }
    @human = Human.find_by!(handle: params.require(:handle))
  end
end
