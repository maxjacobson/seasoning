require "test_helper"

# unit tests for Human model
class HumanTest < ActiveSupport::TestCase
  test "it normalizes handles to a slug-like thing" do
    human = Human.create!(handle: "Marc Paffi", email: "marc@example.com")

    assert_equal "marc_paffi", human.handle
  end

  test "can create human without password" do
    human = Human.create!(
      handle: "donna",
      email: "donna@example.com"
    )

    assert_not human.uses_password?
  end

  test "can create human with password" do
    human = Human.create!(
      handle: "cameron",
      email: "cameron@example.com",
      password: "mutiny-forever-1985",
      password_confirmation: "mutiny-forever-1985"
    )

    assert_predicate human, :uses_password?
    assert human.authenticate("mutiny-forever-1985")
  end

  test "password must be at least 12 characters" do
    human = Human.new(
      handle: "gordon",
      email: "gordon@example.com",
      password: "short",
      password_confirmation: "short"
    )

    assert_not human.valid?
    assert_includes human.errors[:password], "is too short (minimum is 12 characters)"
  end

  test "password confirmation must match" do
    human = Human.new(
      handle: "joe",
      email: "joe@example.com",
      password: "long-enough-password",
      password_confirmation: "different-password"
    )

    assert_not human.valid?
    assert_includes human.errors[:password_confirmation], "doesn't match Password"
  end

  test "can add password to existing passwordless account" do
    human = Human.create!(
      handle: "bosworth",
      email: "bosworth@example.com"
    )

    assert_not human.uses_password?

    human.update!(
      password: "cardiff-electric-1983",
      password_confirmation: "cardiff-electric-1983"
    )

    human.reload

    assert_predicate human, :uses_password?
    assert human.authenticate("cardiff-electric-1983")
  end

  test "can change existing password" do
    human = Human.create!(
      handle: "haley",
      email: "haley@example.com",
      password: "old-password-here-long",
      password_confirmation: "old-password-here-long"
    )

    human.update!(
      password: "new-password-here-long",
      password_confirmation: "new-password-here-long"
    )

    human.reload

    assert human.authenticate("new-password-here-long")
    assert_not human.authenticate("old-password-here-long")
  end
end
