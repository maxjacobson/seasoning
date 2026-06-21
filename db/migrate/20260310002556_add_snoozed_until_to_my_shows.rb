class AddSnoozedUntilToMyShows < ActiveRecord::Migration[8.1]
  def change
    add_column :my_shows, :snoozed_until, :datetime
  end
end
