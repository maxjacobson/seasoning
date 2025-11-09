namespace :new_season_checker do
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task toggle: :environment do
    my_shows = MyShow.where(status: ["waiting_for_more", "finished"])
    my_shows.find_each do |my_show|
      puts "Checking for new seasons for #{my_show.show.slug} for #{my_show.human.handle} asynchronously"
      CheckForNewSeasonsJob.perform_async(my_show.id)
    end

    puts "Waiting for all jobs to finish"
    SuckerPunch::Queue.wait
  end
end
