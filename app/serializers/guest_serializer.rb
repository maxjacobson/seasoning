# frozen_string_literal: true

# Serializes the guest to JSON
class GuestSerializer < Oj::Serializer
  attributes :authenticated
  serializer_attributes :human

  def human
    HumanSerializer.one(guest.human) if guest.human
  end
end
