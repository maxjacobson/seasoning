# frozen_string_literal: true

# Experimenting with the idea of letting people track which episodes they've seen
# which will require tracking what episodes a show has... let's start setting that up!
class CreateEpisodes < ActiveRecord::Migration[7.0]
  def change
    create_table :episodes do |t|
      t.string :name,
               null: false,
               comment: "The episode's official name"
      t.string :still_path, null: true, comment: "TMDB path to a photo related to the episode"
      t.integer :tmdb_id, null: false, comment: "The episode's id on TMDB"
      t.integer :episode_number, null: false, comment: "The position of the episode in the season"
      t.references :season, null: false, comment: "Which season this episode is part of"
      t.timestamps
    end

    add_index :episodes, %i[season_id episode_number], unique: true
    add_index :episodes, %i[tmdb_id], unique: true
  end
end
