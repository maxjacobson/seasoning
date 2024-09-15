# Persist the configuration for the movie database API, as recommended here:
# https://developers.themoviedb.org/3/configuration/get-api-configuration
#
class AddTheMovieDatabaseAPIConfiguration < ActiveRecord::Migration[6.1]
  def change
    create_table :tmdb_api_configurations do |t|
      t.string :secure_base_url, null: false
      t.timestamp :fetched_at, null: false
      t.string :poster_sizes, null: false, array: true

      t.timestamps
    end

    add_index :tmdb_api_configurations, :poster_sizes, using: "gin"
  end
end
