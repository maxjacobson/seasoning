module API
  # Lets people follow each other
  class FollowsController < ApplicationController
    def create
      authorize! { current_human.present? }

      followee = Human.find_by!(handle: params.require(:followee))

      Follow.create_or_find_by(
        followee_id: followee.id,
        follower_id: current_human.id
      )

      render json: {
        profile: ProfileSerializer.one(Profile.new(human: followee, viewer: current_human))
      }
    end
  end
end
