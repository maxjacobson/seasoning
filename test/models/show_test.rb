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

  test "#skipped_seasons_for? returns true when human has skipped seasons" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    MySeason.create!(human: human, season: season, skipped: true)

    assert show.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? returns false when human has no skipped seasons" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    MySeason.create!(human: human, season: season, skipped: false)

    assert_not show.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? returns false when human has no my_seasons for this show" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    assert_not show.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? only checks seasons for this show" do
    show1 = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    show2 = Show.create!(title: "Other Show", tmdb_tv_id: 456)
    Season.create!(show: show1, season_number: 1, name: "Season 1", tmdb_id: 789, episode_count: 1)
    season2 = Season.create!(show: show2, season_number: 1, name: "Season 1", tmdb_id: 890, episode_count: 1)
    human = Human.create!(handle: "donna", email: "donna@example.com")

    MySeason.create!(human: human, season: season2, skipped: true)

    assert_not show1.skipped_seasons_for?(human)
    assert show2.skipped_seasons_for?(human)
  end

  test "#skipped_seasons_for? returns false when human is nil" do
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)

    assert_not show.skipped_seasons_for?(nil)
  end

  test "sets sort_by_title on create by stripping leading articles" do
    # Test "The"
    show1 = Show.create!(title: "The Wire", tmdb_tv_id: 1)

    assert_equal "Wire", show1.sort_by_title

    # Test "A"
    show2 = Show.create!(title: "A Good Show", tmdb_tv_id: 2)

    assert_equal "Good Show", show2.sort_by_title

    # Test "An"
    show3 = Show.create!(title: "An Amazing Show", tmdb_tv_id: 3)

    assert_equal "Amazing Show", show3.sort_by_title

    # Test case-insensitivity
    show4 = Show.create!(title: "the Office", tmdb_tv_id: 4)

    assert_equal "Office", show4.sort_by_title

    # Test no leading article
    show5 = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 5)

    assert_equal "Halt and Catch Fire", show5.sort_by_title

    # Test article not at the beginning
    show6 = Show.create!(title: "Breaking the Law", tmdb_tv_id: 6)

    assert_equal "Breaking the Law", show6.sort_by_title
  end

  test "updates sort_by_title when title changes" do
    show = Show.create!(title: "Original Title", tmdb_tv_id: 1)

    assert_equal "Original Title", show.sort_by_title

    show.update!(title: "The New Title")

    assert_equal "New Title", show.sort_by_title
  end

  test "#refresh! marks seasons not in TMDB response as orphaned" do
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

    show.refresh!

    orphan_season.reload

    assert_predicate orphan_season, :orphaned?, "Season not in TMDB response should be marked as orphaned"

    show.seasons.where.not(id: orphan_season.id).find_each do |season|
      assert_not season.orphaned?, "Season #{season.name} in TMDB response should not be orphaned"
    end
  end

  test "#refresh! un-orphans a previously orphaned season when it reappears in TMDB" do
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

    show.refresh!

    season_1.reload

    assert_not season_1.orphaned?, "Previously orphaned season should be un-orphaned when it reappears"
  end

  test "#refresh! marks show as orphaned when TMDB returns 404" do
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

    show.refresh!

    show.reload

    assert_predicate show, :orphaned?, "Show should be marked as orphaned when TMDB returns 404"
  end

  test "#refresh! un-orphans a previously orphaned show on successful refresh" do
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

    show.refresh!

    show.reload

    assert_not show.orphaned?, "Previously orphaned show should be un-orphaned on successful refresh"
  end

  test "#refresh! handles transaction rollback on API errors" do
    show = Show.create!(
      title: "Halt and Catch Fire",
      slug: "halt-and-catch-fire",
      tmdb_tv_id: 59_659
    )

    stub_request(:get, "https://api.themoviedb.org/3/tv/59659?api_key=xxxx")
      .to_return(status: 500, body: "Internal Server Error")

    error = assert_raises(RuntimeError) do
      show.refresh!
    end

    assert_match(/Net::HTTPInternalServerError/, error.message)

    show.reload

    assert_nil show.tmdb_last_refreshed_at
  end
end
