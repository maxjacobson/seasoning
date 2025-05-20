class SeasonReviewsController < ApplicationController
  def new
    authorize! { current_human.present? }
  end
end
