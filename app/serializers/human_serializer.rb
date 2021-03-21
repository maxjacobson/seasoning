# frozen_string_literal: true

# Serializes a human
class HumanSerializer < Oj::Serializer
  attributes :handle, :gravatar_url
end
