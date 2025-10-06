require "application_system_test_case"

class ReturningShowNotificationsTest < ApplicationSystemTestCase
  test "can dismiss returning show notifications" do
    # Create test data
    human = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345,
                        first_air_date: Time.zone.today)
    ReturningShowNotification.create!(human: human, show: show)

    # Create magic link and authenticate
    magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(magic_link.token)

    # Should be on shows page and see the notification
    assert_current_path shows_path
    assert_text "Halt and Catch Fire is back!"

    # Click dismiss button
    click_button "×"

    # Should redirect back to shows page without notification
    assert_current_path shows_path
    assert_no_text "Halt and Catch Fire is back!"
  end

  test "notification link works correctly" do
    # Create test data
    human = Human.create!(email: "cameron@example.com", handle: "cameron")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345,
                        first_air_date: Time.zone.today)
    ReturningShowNotification.create!(human: human, show: show)

    # Create magic link and authenticate
    magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(magic_link.token)

    # Should be on shows page and see the notification
    assert_current_path shows_path
    assert_text "Halt and Catch Fire is back!"

    # Click on show link in notification
    click_link "Halt and Catch Fire is back!"

    assert_current_path show_path("halt-and-catch-fire")
  end
end
