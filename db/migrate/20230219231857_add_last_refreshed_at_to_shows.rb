# frozen_string_literal: true

# I like the idea of tracking this so I can display it
#
class AddLastRefreshedAtToShows < ActiveRecord::Migration[7.0]
  def change
    change_table :shows do |t|
      t.timestamp :tmdb_last_refreshed_at, null: true, comment: "When did we last refresh this show's info from TMDB?"
    end
  end
end
