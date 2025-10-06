require "test_helper"

class ReturningShowNotificationTest < ActiveSupport::TestCase
  test "belongs to human and show" do
    human = Human.create!(email: "donna@example.com", handle: "donna")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345,
                        first_air_date: Time.zone.today)

    notification = ReturningShowNotification.create!(human: human, show: show)

    assert_equal human, notification.human
    assert_equal show, notification.show
  end

  test "validates uniqueness of human and show combination" do
    human = Human.create!(email: "gordon@example.com", handle: "gordon")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345,
                        first_air_date: Time.zone.today)

    ReturningShowNotification.create!(human: human, show: show)

    duplicate = ReturningShowNotification.new(human: human, show: show)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:human_id], "has already been taken"
  end

  test "can create notifications for different humans on same show" do
    human1 = Human.create!(email: "cameron@example.com", handle: "cameron")
    human2 = Human.create!(email: "joe@example.com", handle: "joe")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345,
                        first_air_date: Time.zone.today)

    notification1 = ReturningShowNotification.create!(human: human1, show: show)
    notification2 = ReturningShowNotification.create!(human: human2, show: show)

    assert_predicate notification1, :valid?
    assert_predicate notification2, :valid?
    assert_not_equal notification1.id, notification2.id
  end
end
