require "test_helper"

class RemoveMyShowTest < ActiveSupport::TestCase
  test "removes existing my_show relationship" do
    human = Human.create!(handle: "donna", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)
    my_show = MyShow.create!(human:, show:)

    assert_difference -> { MyShow.count }, -1 do
      RemoveMyShow.call(show, human)
    end

    assert_not MyShow.exists?(my_show.id)
  end

  test "raises ArgumentError when no relationship exists" do
    human = Human.create!(handle: "donna", email: "donna@example.com")
    show = Show.create!(title: "Halt and Catch Fire", slug: "halt-and-catch-fire", tmdb_tv_id: 12_345)

    error = assert_raises(ArgumentError) do
      RemoveMyShow.call(show, human)
    end

    assert_equal "No relationship to destroy", error.message
  end
end
