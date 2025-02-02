# This app is about TV shows, so let's make sure we can record them
class CreateShows < ActiveRecord::Migration[6.1]
  def change
    create_table :shows do |t|
      t.string :title,
               null: false,
               comment: "The show's official title"
      t.string :slug,
               null: false,
               comment: "The show's title, in slug form, to go in a URL"

      t.timestamps
    end

    add_index :shows, [:slug], unique: true

    create_table :my_shows do |t|
      t.references :human, null: false, comment: "Which human has saved this show"
      t.references :show, null: false, comment: "Which show this human has saved"

      t.timestamps
    end

    add_foreign_key :my_shows, :humans, on_delete: :cascade
    add_foreign_key :my_shows, :shows, on_delete: :cascade
    add_index :my_shows, [:human_id, :show_id], unique: true
  end
end
