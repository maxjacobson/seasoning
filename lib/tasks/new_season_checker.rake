namespace :new_season_checker do
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task toggle: :environment do
    my_shows = MyShow.where(status: ["waiting_for_more", "finished"])
    my_shows.find_each do |my_show|
      show = my_show.show
      human = my_show.human
      if my_show.any_new_unwatched_seasons?
        puts "Moving #{show.slug} to next up for #{human.handle}"

        # Create notification for the returning show
        ReturningShowNotification.create_or_find_by!(
          human:,
          show:
        )

        my_show.status = "next_up"
        my_show.save!
      end
    end
  end
end
