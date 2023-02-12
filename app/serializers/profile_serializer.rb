# frozen_string_literal: true

# Renders the data for the profile page
class ProfileSerializer < Oj::Serializer
  object_as :profile

  serializer_attributes :handle, :created_at
  serializer_attributes :currently_watching, if: -> { profile.human.share_currently_watching? }
  serializer_attributes :your_relationship, if: -> { profile.viewer.present? }

  def handle
    profile.human.handle
  end

  def created_at
    profile.human.created_at
  end

  def currently_watching
    shows = profile.human.shows.where(my_shows: { status: "currently_watching" }).order(title: :asc)

    ShowSerializer.many(shows)
  end

  def your_relationship
    {
      self: profile.human == profile.viewer,
      you_follow_them: profile.human.followers.include?(profile.viewer),
      they_follow_you: profile.viewer.followers.include?(profile.human)
    }
  end
end
