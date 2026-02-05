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

  test "marks seasons not in TMDB response as orphaned" do
    show = Show.create!(
      title: "Halt and Catch Fire",
      slug: "halt-and-catch-fire",
      tmdb_tv_id: 59_659
    )

    orphan_season = show.seasons.create!(
      tmdb_id: 99_999,
      name: "Season 5",
      season_number: 5,
      episode_count: 10,
      air_date: "2020-01-01"
    )

    stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire.json").read
      )

    (1..4).each do |season_number|
      stub_request(:get, "https://api.themoviedb.org/3/tv/59659/season/#{season_number}?api_key=xxxx")
        .to_return(
          status: 200,
          body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire-season-#{season_number}.json").read
        )
    end

    RefreshShow.call(show)

    orphan_season.reload

    assert_predicate orphan_season, :orphaned?, "Season not in TMDB response should be marked as orphaned"

    show.seasons.where.not(id: orphan_season.id).find_each do |season|
      assert_not season.orphaned?, "Season #{season.name} in TMDB response should not be orphaned"
    end
  end

  test "un-orphans a previously orphaned season when it reappears in TMDB" do
    show = Show.create!(
      title: "Halt and Catch Fire",
      slug: "halt-and-catch-fire",
      tmdb_tv_id: 59_659
    )

    season_1 = show.seasons.create!(
      tmdb_id: 60_448,
      name: "Season 1",
      season_number: 1,
      episode_count: 10,
      air_date: "2014-06-01",
      orphaned: true
    )

    stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire.json").read
      )

    (1..4).each do |season_number|
      stub_request(:get, "https://api.themoviedb.org/3/tv/59659/season/#{season_number}?api_key=xxxx")
        .to_return(
          status: 200,
          body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire-season-#{season_number}.json").read
        )
    end

    RefreshShow.call(show)

    season_1.reload

    assert_not season_1.orphaned?, "Previously orphaned season should be un-orphaned when it reappears"
  end

  test "marks show as orphaned when TMDB returns 404" do
    show = Show.create!(
      title: "Halt and Catch Fire",
      slug: "halt-and-catch-fire",
      tmdb_tv_id: 59_659
    )

    not_found_body = <<~JSON
      {"status_code":34,"status_message":"The resource you requested could not be found."}
    JSON

    stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
      .to_return(status: 404, body: not_found_body)

    RefreshShow.call(show)

    show.reload

    assert_predicate show, :orphaned?, "Show should be marked as orphaned when TMDB returns 404"
  end

  test "un-orphans a previously orphaned show on successful refresh" do
    show = Show.create!(
      title: "Halt and Catch Fire",
      slug: "halt-and-catch-fire",
      tmdb_tv_id: 59_659,
      orphaned: true
    )

    stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
      .to_return(
        status: 200,
        body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire.json").read
      )

    (1..4).each do |season_number|
      stub_request(:get, "https://api.themoviedb.org/3/tv/59659/season/#{season_number}?api_key=xxxx")
        .to_return(
          status: 200,
          body: Rails.root.join("test/webmock/tmdb/halt-and-catch-fire-season-#{season_number}.json").read
        )
    end

    RefreshShow.call(show)

    show.reload

    assert_not show.orphaned?, "Previously orphaned show should be un-orphaned on successful refresh"
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
