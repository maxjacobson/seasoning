require "application_system_test_case"

# System test covering visiting credits page
class ReadingCreditsTest < ApplicationSystemTestCase
  test "credits page loads" do
    visit credits_path

    assert_content "Letterboxd"
  end
end
