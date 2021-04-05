# frozen_string_literal: true

# Render info about a human's relationship to a season, if any
class MySeasonSerializer < Oj::Serializer
  object_as :my_season

  serializer_attributes :show, :season
  serializer_attributes :your_relationship, if: -> { my_season.persisted? }

  def show
    ShowSerializer.one(my_season.season.show)
  end

  def season
    SeasonSerializer.one(my_season.season)
  end

  def your_relationship
    {
      watched: my_season.watched
    }
  end
end
