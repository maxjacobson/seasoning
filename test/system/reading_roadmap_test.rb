require "application_system_test_case"

# System test covering visiting roadmap page
class ReadingRoadmapTest < ApplicationSystemTestCase
  test "roadmap page loads" do
    visit roadmap_path

    assert_content "Roadmap"
  end
end
