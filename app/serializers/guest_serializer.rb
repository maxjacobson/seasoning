# Serializes the guest to JSON
class GuestSerializer < Oj::Serializer
  serializer_attributes :human, :authenticated

  def authenticated
    guest.authenticated?
  end

  def human
    HumanSerializer.one(guest.human) if guest.human
  end
end
