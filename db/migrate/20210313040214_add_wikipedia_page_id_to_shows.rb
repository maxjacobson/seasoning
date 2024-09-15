# Now that we're importing TV show data from Wikipedia, it may be helpful to record which page it came from
class AddWikipediaPageIdToShows < ActiveRecord::Migration[6.1]
  def change
    change_table :shows do |t|
      # rubocop:disable Rails/NotNullColumn
      t.integer :wikipedia_page_id, null: false
      # rubocop:enable Rails/NotNullColumn
    end
  end
end
