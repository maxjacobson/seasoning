# frozen_string_literal: true

namespace :tmdb do
  # Refresh the configuration record
  #
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task refresh_config: :environment do
    TMDBAPIConfiguration.refresh!
  end
end
