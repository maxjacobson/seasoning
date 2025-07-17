require "test_helper"

class BoomJobTest < ActiveJob::TestCase
  test "perform raises the argument as an error" do
    job = BoomJob.new

    error = assert_raises(RuntimeError) do
      job.perform("test message")
    end

    assert_equal '"test message"', error.message
  end
end
