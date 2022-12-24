# frozen_string_literal: true

module API
  # lists who someone is following
  class ProfileFollowsController < ApplicationController
    def index
      authorize! { true }

      profile = Human.find_by!(handle: params.require(:profile_id))

      render json: {
        humans: HumanSerializer.many(profile.followings)
      }
    end
  end
end
