# show the upcoming roadmap
class RoadmapsController < ApplicationController
  def show
    authorize! { true }
  end
end
