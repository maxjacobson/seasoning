class AddSkippedToMySeasons < ActiveRecord::Migration[8.2]
  def change
    add_column :my_seasons, :skipped, :boolean, default: false, null: false
  end
end
