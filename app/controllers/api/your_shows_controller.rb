module API
  # Exposes all of the current human's shows -- ones that they have saved
  class YourShowsController < ApplicationController
    def create
      authorize! { current_human.present? }

      show = Show.find(params.require(:show).require(:id))

      my_show = MyShow.create_or_find_by(human: current_human, show:)

      render json: {
        your_show: MyShowSerializer.one(my_show)
      }
    end

    def update
      authorize! { current_human.present? }

      show = Show.find_by(slug: params.require(:id))

      my_show = MyShow.find_by!(human: current_human, show:)

      if my_show.update(params.expect(show: [:note_to_self, :status]))
        render json: MyShowSerializer.one(my_show)
      else
        render json: {}, status: :bad_request
      end
    end

    def destroy
      authorize! { current_human.present? }

      show = Show.find_by(slug: params.require(:id))
      RemoveMyShow.call(show, current_human)

      render json: {}
    end
  end
end
