class ReplaceAvailableSameDayWithAvailabilityOffset < ActiveRecord::Migration[8.1]
  def up
    add_column :my_shows, :availability_offset, :integer, default: 0, null: false
    execute "update my_shows set availability_offset = 1 where available_same_day = false"
    remove_column :my_shows, :available_same_day
  end

  def down
    add_column :my_shows, :available_same_day, :boolean, default: true, null: false
    execute "update my_shows set available_same_day = false where availability_offset > 0"
    remove_column :my_shows, :availability_offset
  end
end
