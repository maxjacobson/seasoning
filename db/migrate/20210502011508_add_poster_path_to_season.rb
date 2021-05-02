# frozen_string_literal: true

# Different seasons can have different posters so why not?
class AddPosterPathToSeason < ActiveRecord::Migration[6.1]
  def change
    change_table :seasons do |t|
      t.string :tmdb_poster_path, null: true
    end
  end
end
