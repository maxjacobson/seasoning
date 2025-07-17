require "test_helper"

class RefreshShowTest < ActiveSupport::TestCase
  test "exists and is callable" do
    assert_respond_to RefreshShow, :call
    assert_kind_of Proc, RefreshShow
  end

  test "requires a show parameter" do
    assert_raises(ArgumentError) do
      RefreshShow.call
    end
  end

  test "handles transaction rollback on API errors" do
    show = Show.create!(
      title: "Halt and Catch Fire",
      slug: "halt-and-catch-fire",
      tmdb_tv_id: 59_659
    )

    # Stub API to return error
    stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
      .to_return(status: 500, body: "Internal Server Error")

    error = assert_raises(RuntimeError) do
      RefreshShow.call(show)
    end

    assert_match(/Net::HTTPInternalServerError/, error.message)

    # Show should not have been updated due to transaction rollback
    show.reload

    assert_nil show.tmdb_last_refreshed_at
  end
end
