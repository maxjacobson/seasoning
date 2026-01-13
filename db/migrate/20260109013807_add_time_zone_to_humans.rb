class AddTimeZoneToHumans < ActiveRecord::Migration[8.2]
  def change
    add_column :humans, :time_zone_name, :string,
               null: false,
               default: "Eastern Time (US & Canada)",
               comment: "The human's time zone name (e.g., 'Eastern Time (US & Canada)')"
  end
end
