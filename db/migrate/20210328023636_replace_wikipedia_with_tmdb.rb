# frozen_string_literal: true

# rubocop:disable Rails/BulkChangeTable
# We're making the switch, baby
class ReplaceWikipediaWithTMDB < ActiveRecord::Migration[6.1]
  def change
    add_column :shows, :tmdb_tv_id, :integer, null: true
    change_column_null :shows, :tmdb_tv_id, false

    remove_column :shows, :wikipedia_page_id, :integer, null: false, default: -1
    remove_column :shows, :number_of_seasons, :integer, null: false, default: -1
  end
end
# rubocop:enable Rails/BulkChangeTable
