# frozen_string_literal: true

module API
  # Exposes all of the current human's shows -- ones that they have saved
  class YourShowsController < ApplicationController
    def index
      authorize! { current_human.present? }

      render json: {
        your_shows: MyShowSerializer.many(current_human.my_shows)
      }
    end

    def create
      authorize! { current_human.present? }

      show = Show.find(params.require(:show).require(:id))

      my_show = MyShow.create_or_find_by(human: current_human, show: show)

      render json: {
        your_show: MyShowSerializer.one(my_show)
      }
    end

    def update
      authorize! { current_human.present? }

      show = Show.find_by(slug: params.require(:id))

      my_show = MyShow.find_by!(human: current_human, show: show)

      if my_show.update(params.require(:show).permit(:note_to_self, :status))
        render json: MyShowSerializer.one(my_show)
      else
        render json: {}, status: 400
      end
    end
  end
end
