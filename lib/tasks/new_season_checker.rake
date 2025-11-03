namespace :new_season_checker do
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task toggle: :environment do
    my_shows = MyShow.where(status: ["waiting_for_more", "finished"])
    my_shows.find_each do |my_show|
      puts "Moved #{my_show.show.slug} to next up for #{my_show.human.handle}" if CheckForNewSeasons.call(my_show)
    end
  end
end
