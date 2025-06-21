require "test_helper"

# unit tests for GuestSerializer
class GuestSerializerTest < ActiveSupport::TestCase
  test "serializes authenticated guest" do
    token = SecureRandom.uuid
    guest = Guest.from(token)
    serialized = GuestSerializer.one(guest).as_json

    assert_equal serialized, { "authenticated" => false, "token" => token, "human" => nil }
  end

  test "serializes unauthenticated guest" do
    human = Human.create!(handle: "derek", email: "derek@example.com")
    browser_session = BrowserSession.create!(human: human)

    guest = Guest.from(browser_session.token)
    serialized = GuestSerializer.one(guest).as_json

    assert_equal serialized, {
      "authenticated" => true,
      "token" => browser_session.token,
      "human" => {
        "handle" => "derek",
        "admin" => false
      }
    }
  end
end
