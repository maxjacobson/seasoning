namespace :tmdb do
  # Refresh the configuration record
  #
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task refresh_config: :environment do
    TMDBAPIConfiguration.refresh!
  end

  # Refresh the shows and seasons records over time.
  #
  # Helps make sure that as new seasons and episodes spring to life, Seasoning is aware.
  #
  # Plus other various changes, like the default poster changing...
  #
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task refresh_shows: :environment do
    Show.needs_refreshing.find_each do |show|
      puts "Refreshing #{show.slug} asynchronously"
      show.refresh_async
    end

    puts "Waiting for all jobs to finish"
    SuckerPunch::Queue.wait
  end

  # Available to run manually if I make changes to the import/refresh flow and want
  # to kick off a full refresh to confirm it's still working
  task refresh_all_shows: :environment do
    Show.find_each do |show|
      puts "Refreshing #{show.slug} asynchronously"
      show.refresh_async
    end

    puts "Waiting for all jobs to finish"
    SuckerPunch::Queue.wait
  end
end
