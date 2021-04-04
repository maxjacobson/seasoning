# frozen_string_literal: true

# Persists the TMDB API configuration as recommended here:
# https://developers.themoviedb.org/3/configuration/get-api-configuration
#
# Is refreshed every few days via https://dashboard.heroku.com/apps/seasoning/scheduler
#
# There should always be exactly one record in this table
class TMDBAPIConfiguration < ApplicationRecord
  def self.refresh!
    transaction do
      most_recent = order(fetched_at: :desc).first
      if most_recent.present? && most_recent.fetched_at > 3.days.ago
        puts "No need to refresh TMDB API Configuration. Was last refreshed #{most_recent.fetched_at}."
        next
      end

      puts "Destroying any existing configs"
      destroy_all
      puts "Fetching latest config"
      api_configuration = TMDB::Client.new.api_configuration

      puts "Persisting the latest config"
      create!(
        fetched_at: Time.now,
        secure_base_url: api_configuration.images.secure_base_url,
        poster_sizes: api_configuration.images.poster_sizes
      )
    end
  end
end
