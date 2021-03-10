# frozen_string_literal: true

module API
  # Provides the data for the public profile page of a human
  class ProfilesController < ApplicationController
    def show
      authorize! { true }
      human = Human.find_by(handle: params.require(:id))

      if human.present?
        render json: {
          profile: {
            handle: human.handle,
            shows: human.shows.map do |show|
              {
                id: show.id,
                title: show.title,
                slug: show.slug
              }
            end
          }
        }
      else
        render json: {}, status: 404
      end
    end
  end
end
