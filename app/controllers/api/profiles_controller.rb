module API
  # Provides the data for the public profile page of a human
  class ProfilesController < ApplicationController
    def show
      authorize! { true }
      human = Human.find_by(handle: params.require(:id))

      if human.present?
        render json: {
          profile: ProfileSerializer.one(Profile.new(human:, viewer: current_human))
        }
      else
        render json: {}, status: :not_found
      end
    end
  end
end
