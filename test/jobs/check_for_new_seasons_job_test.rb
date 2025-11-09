require "test_helper"

class CheckForNewSeasonsJobTest < ActiveJob::TestCase
  test "perform finds my_show and calls CheckForNewSeasons" do
    job = CheckForNewSeasonsJob.new

    human = Human.create!(handle: "cameron", email: "cameron@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")

    season = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    job.perform(my_show.id)

    my_show.reload

    assert_equal "next_up", my_show.status
    assert ReturningShowNotification.exists?(human: human, show: show)
  end

  test "perform does nothing when no new seasons available" do
    job = CheckForNewSeasonsJob.new

    human = Human.create!(handle: "cameron", email: "cameron@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")

    job.perform(my_show.id)

    my_show.reload

    assert_equal "waiting_for_more", my_show.status
    assert_not ReturningShowNotification.exists?(human: human, show: show)
  end

  test "perform raises error when my_show not found" do
    job = CheckForNewSeasonsJob.new

    assert_raises(ActiveRecord::RecordNotFound) do
      job.perform(999_999)
    end
  end

  test "perform does not change status when new season is skipped" do
    job = CheckForNewSeasonsJob.new

    human = Human.create!(handle: "cameron", email: "cameron@example.com")
    show = Show.create!(title: "Halt and Catch Fire", tmdb_tv_id: 123)
    my_show = MyShow.create!(human: human, show: show, status: "waiting_for_more")

    season1 = Season.create!(show: show, season_number: 1, name: "Season 1", tmdb_id: 456, episode_count: 1)
    Episode.create!(season: season1, episode_number: 1, air_date: 1.day.ago, tmdb_id: 789, name: "Episode 1")

    season2 = Season.create!(show: show, season_number: 2, name: "Season 2", tmdb_id: 457, episode_count: 1)
    Episode.create!(season: season2, episode_number: 1, air_date: 1.day.ago, tmdb_id: 790, name: "Episode 1")

    MySeason.create!(human: human, season: season1, watched_episode_numbers: [1])
    MySeason.create!(human: human, season: season2, skipped: true)

    job.perform(my_show.id)

    my_show.reload

    assert_equal "waiting_for_more", my_show.status
    assert_not ReturningShowNotification.exists?(human: human, show: show)
  end
end
