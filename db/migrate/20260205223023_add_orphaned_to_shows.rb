class AddOrphanedToShows < ActiveRecord::Migration[8.2]
  def change
    add_column :shows, :orphaned, :boolean, default: false, null: false,
                                            comment: "No longer present in the TMDB API response"
  end
end
