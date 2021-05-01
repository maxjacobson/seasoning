# frozen_string_literal: true

class SeasonReviewSerializer < Oj::Serializer
  attributes(
    :body,
    :visibility,
    :created_at,
    :updated_at,
    :rating,
    :viewing,
    :id
  )
  has_one :author, serializer: HumanSerializer
  has_one :season, serializer: SeasonSerializer
end
