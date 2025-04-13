# people can write notes to self to remind them why they added a show
class NotesToSelfController < ApplicationController
  def edit
    authorize! { current_human.present? }

    @show = Show.find_by!(slug: params[:show_slug])
    @my_show = MyShow.find_by!(human: current_human, show: @show)
  end
end
