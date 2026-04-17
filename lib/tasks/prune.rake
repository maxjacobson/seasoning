namespace :prune do
  # Run daily via systemd timer (seasoning-nightly.service)
  task all: :environment do
    links = MagicLink.inactive.destroy_all
    puts "Destroyed #{links.count} magic links"
  end
end
