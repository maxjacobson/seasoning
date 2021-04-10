# frozen_string_literal: true

# Records the relationship between people
class Follow < ApplicationRecord
  validate :no_self_follow

  private

  def no_self_follow
    return unless follower_id == followee_id && follower_id.present?

    errors.add(:base, "Cannot follow yourself")
  end
end
