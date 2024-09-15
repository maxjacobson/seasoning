module API
  # Lets you search the shows so you can add some
  class ShowsController < ApplicationController
    def index
      authorize! { current_human.present? }

      query = params.require(:q)
      shows = Show.where("title ilike ?", "%#{query}%")
      render json: {
        shows: ShowSerializer.many(shows)
      }
    end

    def show
      authorize! { true }

      show = Show.find_by!(slug: params.fetch(:id))
      my_show = MyShow.find_or_initialize_by(human: current_human, show:)

      render json: MyShowSerializer.one(my_show)
    end
  end
end
