# Exposes a profile's followings
class FollowingsController < ApplicationController
  def index
    authorize! { true }
    @profile = Human.find_by!(handle: params[:handle])
  end
end
