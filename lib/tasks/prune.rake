namespace :prune do
  # This just prunes some records which don't strictly need to exist anymore.
  # We're nowhere near hitting it, but there is a 10k rows limit in our database
  # that we will quickly hit if the site actually takes off, so this is just
  # to help delay that a little.
  #
  # Run daily via https://dashboard.heroku.com/apps/seasoning/scheduler
  task all: :environment do
    links = MagicLink.inactive.destroy_all
    puts "Destroyed #{links.count} magic links"
  end
end
