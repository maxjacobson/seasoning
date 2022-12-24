# frozen_string_literal: true

module API
  # Lists who follows someone
  class ProfileFollowersController < ApplicationController
    def index
      authorize! { true }

      profile = Human.find_by!(handle: params.require(:profile_id))

      render json: {
        humans: HumanSerializer.many(profile.followers)
      }
    end
  end
end
