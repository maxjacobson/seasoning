# The first step toward importing rich data about shows.
# Lays the groundwork for letting people keep track of what
# season they're up to and write reviews about them.
class AddSeasonCountToShows < ActiveRecord::Migration[6.1]
  def change
    change_table :shows do |t|
      t.integer :number_of_seasons,
                null: true,
                comment: "How many seasons there are"
    end
  end
end
