require "application_system_test_case"

# System test covering visiting changelog page
class ReadingChangelogTest < ApplicationSystemTestCase
  test "changelog page loads" do
    visit changelog_path

    assert page.has_content?("Development starts")
  end
end
