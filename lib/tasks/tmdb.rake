# frozen_string_literal: true

namespace :tmdb do
  # Refresh the configuration record
  #
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task refresh_config: :environment do
    TMDBAPIConfiguration.refresh!
  end

  # Refresh the shows and seasons records over time.
  #
  # Helps make sure that as new seasons spring to life, Seasoning is aware.
  #
  # Plus other various changes, like the default poster changing...
  #
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task refresh_shows: :environment do
    Show.needs_refreshing.find_each do |show|
      puts "Refreshing #{show.slug}"
      show.refresh!
    end
  end
end
