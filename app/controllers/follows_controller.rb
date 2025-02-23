# CRUD actions for human follows
class FollowsController < ApplicationController
  def create
    authorize! { current_human.present? }

    followee = Human.find(params[:followee_id])

    Follow.create_or_find_by!(
      followee_id: followee.id,
      follower_id: current_human.id
    )

    redirect_to human_profile_path(followee.handle), notice: "Followed!"
  end

  def destroy
    authorize! { current_human.present? }

    followee = Human.find(params[:followee_id])

    Follow.where(
      followee_id: followee.id,
      follower_id: current_human.id
    ).destroy_all

    redirect_to human_profile_path(followee.handle), notice: "Unfollowed!"
  end
end
