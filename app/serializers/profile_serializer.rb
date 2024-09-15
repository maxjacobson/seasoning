# Renders the data for the profile page
class ProfileSerializer < Oj::Serializer
  object_as :profile

  serializer_attributes :handle, :created_at, :reviews_count, :followers_count, :following_count
  serializer_attributes :currently_watching, if: -> { profile.human.share_currently_watching? }
  serializer_attributes :your_relationship, if: -> { profile.viewer.present? }

  def handle
    profile.human.handle
  end

  def created_at
    profile.human.created_at
  end

  def currently_watching
    shows = profile.human.shows.where(my_shows: { status: "currently_watching" }).alphabetical

    ShowSerializer.many(shows)
  end

  def reviews_count
    profile.human.season_reviews.count
  end

  def followers_count
    profile.human.followers.count
  end

  def following_count
    profile.human.followings.count
  end

  def your_relationship
    {
      self: profile.human == profile.viewer,
      you_follow_them: profile.human.followers.include?(profile.viewer),
      they_follow_you: profile.viewer.followers.include?(profile.human)
    }
  end
end
