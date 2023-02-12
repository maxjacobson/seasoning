# frozen_string_literal: true

# Let's track show first air date!
class AddFirstAirDateToShows < ActiveRecord::Migration[7.0]
  def change
    change_table :shows do |t|
      t.date :first_air_date, null: true, comment: "What date did this show first air?"
    end
  end
end
