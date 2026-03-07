require "application_system_test_case"

class ProgressiveWebAppRoutesTest < ApplicationSystemTestCase
  test "manifest is accessible" do
    visit "/manifest.json"

    assert_content "Seasoning"
  end

  test "offline page is accessible" do
    visit offline_path

    assert_content "You're offline"
  end
end
