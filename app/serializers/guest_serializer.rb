# frozen_string_literal: true

# Serializes the guest to JSON
class GuestSerializer < Oj::Serializer
  attributes :authenticated, :name
end
