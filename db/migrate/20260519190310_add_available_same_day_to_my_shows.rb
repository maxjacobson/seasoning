class AddAvailableSameDayToMyShows < ActiveRecord::Migration[8.2]
  def change
    add_column :my_shows, :available_same_day, :boolean, default: true, null: false
  end
end
