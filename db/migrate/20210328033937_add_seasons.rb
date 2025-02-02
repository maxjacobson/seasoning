# Let's start tracking seasons in seasoning. That's what we came here to do, no?
class AddSeasons < ActiveRecord::Migration[6.1]
  def change
    create_table :seasons do |t|
      t.references :show, null: false, comment: "Which show this season is part of"
      t.integer :tmdb_id, null: false
      t.string :name, null: false
      t.integer :season_number, null: false
      t.integer :episode_count, null: false
      t.string :slug, null: false, comment: "A URL-friendly slug"

      t.timestamps
    end

    add_index :shows, [:tmdb_tv_id], unique: true
    add_index :seasons, [:show_id, :slug], unique: true
    add_index :seasons, [:tmdb_id], unique: true
  end
end
