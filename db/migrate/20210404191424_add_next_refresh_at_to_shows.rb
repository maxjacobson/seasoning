# Supports the feature to keep our data up-to-date over time
class AddNextRefreshAtToShows < ActiveRecord::Migration[6.1]
  def change
    change_table :shows do |t|
      t.timestamp :tmdb_next_refresh_at, null: true
    end
  end
end
