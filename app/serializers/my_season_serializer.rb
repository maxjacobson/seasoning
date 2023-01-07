# frozen_string_literal: true

# Render info about a human's relationship to a season, if any
class MySeasonSerializer < Oj::Serializer
  object_as :my_season

  serializer_attributes :show, :season
  serializer_attributes :your_relationship, if: -> { my_season.persisted? }
  serializer_attributes :your_reviews, if: -> { my_season.human.present? }

  def show
    ShowSerializer.one(my_season.season.show)
  end

  def season
    SeasonSerializer.one(my_season.season)
  end

  def your_relationship
    {
      watched: my_season.watched?
    }
  end

  def your_reviews
    SeasonReviewSerializer.many(my_season.reviews.order(created_at: :desc))
  end
end
