# frozen_string_literal: true

# Serializes the guest to JSON
class GuestSerializer < Oj::Serializer
  attributes :authenticated, :token

  attribute \
  def human
    HumanSerializer.one(guest.human) if guest.human
  end
end
