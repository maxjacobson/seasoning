require "application_system_test_case"

# System test covering password-based login
class PasswordLoginTest < ApplicationSystemTestCase
  setup do
    @donna = Human.create!(
      handle: "donna",
      email: "donna@example.com",
      password: "halt-and-catch-fire-2024",
      password_confirmation: "halt-and-catch-fire-2024"
    )
  end

  test "signing in with valid password" do
    visit login_path

    within "[data-test-id='password-section']" do
      fill_in "Email", with: "donna@example.com"
      fill_in "Password", with: "halt-and-catch-fire-2024"
      click_on "Sign in"
    end

    assert_content "No shows yet"
    assert_equal "/shows", page.current_path
  end

  test "signing in with invalid password" do
    visit login_path

    within "[data-test-id='password-section']" do
      fill_in "Email", with: "donna@example.com"
      fill_in "Password", with: "wrong-password"
      click_on "Sign in"
    end

    assert_content "Invalid email or password"
  end

  test "signing in with non-existent email" do
    visit login_path

    within "[data-test-id='password-section']" do
      fill_in "Email", with: "nobody@example.com"
      fill_in "Password", with: "some-password"
      click_on "Sign in"
    end

    assert_content "Invalid email or password"
  end

  test "login page has both password and magic link sections" do
    visit login_path

    assert_content "With password"
    assert_content "With magic link"
  end

  test "root page has sign in and sign up links" do
    visit root_path

    assert_selector "a", text: "Sign in"
    assert_selector "a", text: "Sign up"
  end
end
