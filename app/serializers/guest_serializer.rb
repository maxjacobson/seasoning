# Serializes the guest to JSON
class GuestSerializer < Oj::Serializer
  attributes :authenticated, :token
  serializer_attributes :human

  def human
    HumanSerializer.one(guest.human) if guest.human
  end
end
