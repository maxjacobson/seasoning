class AddAirDateToSeasons < ActiveRecord::Migration[8.1]
  def change
    add_column :seasons, :air_date, :date
  end
end
