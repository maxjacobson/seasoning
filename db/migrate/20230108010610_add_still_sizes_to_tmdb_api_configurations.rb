# frozen_string_literal: true

# If we're going to display episode stills, we need to store this configuration
class AddStillSizesToTMDBAPIConfigurations < ActiveRecord::Migration[7.0]
  def change
    change_table :tmdb_api_configurations do |t|
      t.string :still_sizes,
               null: true,
               array: true,
               comment: "Available sizes for episode stills"
    end
  end
end
