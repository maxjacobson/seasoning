require "test_helper"

class RefreshShowJobTest < ActiveJob::TestCase
  test "perform finds show and calls refresh!" do
    job = RefreshShowJob.new

    show = Minitest::Mock.new
    show.expect(:slug, "halt-and-catch-fire")
    show.expect(:refresh!, nil)
    show.expect(:id, 1234)
    Show.stub(:find, show) do
      job.perform(show.id)
    end

    assert show.verify
  end

  test "perform raises error when show not found" do
    job = RefreshShowJob.new

    assert_raises(ActiveRecord::RecordNotFound) do
      job.perform(999_999)
    end
  end
end
