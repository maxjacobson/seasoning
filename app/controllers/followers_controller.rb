# Exposes a profile's followers
class FollowersController < ApplicationController
  def index
    authorize! { true }
    @profile = Human.find_by!(handle: params[:handle])
  end
end
