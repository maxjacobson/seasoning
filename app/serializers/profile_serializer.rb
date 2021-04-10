# frozen_string_literal: true

# Renders the data for the profile page
class ProfileSerializer < Oj::Serializer
  object_as :human

  attributes :handle, :created_at
  serializer_attributes :currently_watching, if: -> { human.share_currently_watching? }

  def currently_watching
    shows = human.shows.where(my_shows: { status: "currently_watching" })

    ShowSerializer.many(shows)
  end
end
