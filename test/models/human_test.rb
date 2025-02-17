require "test_helper"

# unit tests for Human model
class HumanTest < ActiveSupport::TestCase
  test "it normalizes handles to a slug-like thing" do
    human = Human.create!(handle: "Marc Paffi", email: "marc@example.com")

    assert_equal "marc_paffi", human.handle
  end
end
