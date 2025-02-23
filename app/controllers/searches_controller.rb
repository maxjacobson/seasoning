# Shows show search results
class SearchesController < ApplicationController
  def show
    authorize! { current_human.present? }

    @shows = if (query = params[:q].to_s.strip.presence)
               Show.where("title ilike ?", "%#{query}%")
             else
               Show.none
             end
  end
end
