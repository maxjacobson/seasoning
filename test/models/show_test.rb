require "test_helper"

class ShowTest < ActiveSupport::TestCase
  test "#watchers_count returns count of humans who have added the show" do
    show = Show.create!(
      title: "Test Show",
      slug: "test-show",
      tmdb_tv_id: 12_345
    )

    # Initially no watchers
    assert_equal 0, show.watchers_count

    # Add some humans who watch the show
    human1 = Human.create!(handle: "donna", email: "donna@example.com")
    human2 = Human.create!(handle: "cameron", email: "cameron@example.com")

    MyShow.create!(human: human1, show: show, status: "currently_watching")
    MyShow.create!(human: human2, show: show, status: "finished")

    # Should count both watchers
    assert_equal 2, show.watchers_count
  end
end
