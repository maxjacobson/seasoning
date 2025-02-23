# Shows show search results
class SearchesController < ApplicationController
  def show
    authorize! { current_human.present? }

    query = params.require(:q)
    @shows = Show.where("title ilike ?", "%#{query}%")
  end
end
