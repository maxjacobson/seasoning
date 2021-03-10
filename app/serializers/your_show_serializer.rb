# frozen_string_literal: true

# Serializes the guest to JSON
class YourShowSerializer < Oj::Serializer
  attributes :id, :title
end
