require "application_system_test_case"

class DebutingShowNotificationsTest < ApplicationSystemTestCase
  test "can dismiss debuting show notifications" do
    human = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345,
                        first_air_date: Time.zone.today)
    DebutingShowNotification.create!(human: human, show: show)

    magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(magic_link.token)

    assert_current_path shows_path
    assert_text "Halt and Catch Fire is here!"

    click_button "×"

    assert_current_path shows_path
    assert_no_text "Halt and Catch Fire is here!"
  end

  test "notification link works correctly" do
    human = Human.create!(email: "cameron@example.com", handle: "cameron")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345,
                        first_air_date: Time.zone.today)
    DebutingShowNotification.create!(human: human, show: show)

    magic_link = MagicLink.create!(email: human.email)
    visit redeem_magic_link_path(magic_link.token)

    assert_current_path shows_path
    assert_text "Halt and Catch Fire is here!"

    click_link "Halt and Catch Fire is here!"

    assert_current_path show_path("halt-and-catch-fire")
  end
end
