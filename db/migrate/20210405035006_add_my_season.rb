# Add a table for tracking info about a human's relationship to a season
class AddMySeason < ActiveRecord::Migration[6.1]
  def change
    create_table :my_seasons do |t|
      t.references :human, null: false, comment: "Which human saved this season"
      t.references :season, null: false, comment: "Which season did this human save"
      t.boolean :watched, null: false, default: false, comment: "Did the human watch this season yet?"

      t.timestamps
    end

    add_index :my_seasons, %i[human_id season_id], unique: true
    add_foreign_key :my_seasons, :seasons, on_delete: :cascade
    add_foreign_key :my_seasons, :humans, on_delete: :cascade
  end
end
