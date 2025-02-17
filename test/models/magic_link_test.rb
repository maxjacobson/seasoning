require "test_helper"

# Unit tests for MagicLink model
class MagicLinkTest < ActiveSupport::TestCase
  test "it normalizes the email" do
    magic_link = MagicLink.new(email: " goRDon@example.com ")

    assert_equal "gordon@example.com", magic_link.email
  end
end
