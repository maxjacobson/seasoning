require "application_system_test_case"

# System tests for sending unauthenticated visitors to the sign in page
class RequiringAuthenticationTest < ApplicationSystemTestCase
  test "visiting the shows page while signed out redirects to sign in" do
    visit shows_path

    assert_current_path login_path
    assert_content "Please sign in to continue."
    assert_selector "[data-test-id='password-section']"
    assert_selector "[data-test-id='magic-link-section']"
  end

  test "visiting a show page while signed out redirects to sign in" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 1)

    visit show_path(show.slug)

    assert_current_path login_path
    assert_content "Please sign in to continue."
  end

  test "visiting settings while signed out redirects to sign in" do
    visit settings_path

    assert_current_path login_path
    assert_content "Please sign in to continue."
  end

  test "visiting an admin page while signed out redirects to sign in" do
    visit admin_path

    assert_current_path login_path
    assert_content "Please sign in to continue."
  end

  test "visiting someone's stats while signed out redirects to sign in" do
    Human.create!(handle: "donna", email: "donna@example.com")

    visit profile_stats_path(handle: "donna")

    assert_current_path login_path
    assert_content "Please sign in to continue."
  end
end
