# Start storing the tmdb poster path on the show record.
#
# May need to refresh this periodically in the future, but I think it's better to persist it...
class AddPosterPathToShows < ActiveRecord::Migration[6.1]
  def change
    change_table :shows do |t|
      t.string :tmdb_poster_path, null: true
    end
  end
end
