# frozen_string_literal: true

# Let's track episode air date!
class AddAirDateToEpisodes < ActiveRecord::Migration[7.0]
  def change
    change_table :episodes do |t|
      t.date :air_date, null: true, comment: "What date did this episode first air?"
    end
  end
end
