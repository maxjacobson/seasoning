# frozen_string_literal: true

# Serializes a human
class HumanSerializer < Oj::Serializer
  object_as :human

  attributes(
    :handle,
    :gravatar_url
  )
end
