# frozen_string_literal: true

module API
  # Exposes all of the current human's shows -- ones that they have saved
  class YourShowsController < ApplicationController
    PAGE_SIZE = 10

    def index
      authorize! { current_human.present? }

      my_shows = current_human
                 .my_shows
                 .joins(:show)
                 .then { |relation| search(relation) }
                 .order(
                   Arel.sql(
                     <<~SQL.squish
                       status asc,
                       regexp_replace(title, '^(The|A)\s', '', 'i')
                     SQL
                   )
                 )
                 .limit(PAGE_SIZE)
                 .offset((current_page - 1) * PAGE_SIZE)

      render json: {
        your_shows: MyShowSerializer.many(my_shows),
        page: current_page
      }
    end

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

      if my_show.update(params.require(:show).permit(:note_to_self, :status))
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

    private

    def search(my_shows)
      my_shows =
        if params[:statuses].is_a?(Array)
          my_shows.where(status: params[:statuses])
        else
          my_shows
        end

      if params[:q].present?
        my_shows.where("shows.title ilike ?", "%#{params[:q]}%")
      else
        my_shows
      end
    end

    def current_page
      Integer(params[:page]).tap do |val|
        raise ArgumentError unless val >= 1
      end
    rescue TypeError, ArgumentError
      1
    end
  end
end
