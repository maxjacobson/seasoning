require "test_helper"

# unit tests for GuestSerializer
class GuestSerializerTest < ActiveSupport::TestCase
  test "serializes unauthenticated guest" do
    guest = Guest.from(nil)
    serialized = GuestSerializer.one(guest).as_json

    assert_equal({ "authenticated" => false, "human" => nil }, serialized)
  end

  test "serializes authenticated guest" do
    human = Human.create!(handle: "derek", email: "derek@example.com")
    guest = Guest.from(human)
    serialized = GuestSerializer.one(guest).as_json

    assert_equal({
                   "authenticated" => true,
                   "human" => {
                     "handle" => "derek",
                     "admin" => false
                   }
                 }, serialized)
  end
end
