class AddLogoSizesToTMDBAPIConfigurations < ActiveRecord::Migration[8.1]
  def change
    add_column :tmdb_api_configurations, :logo_sizes, :string, array: true, null: false, default: []
  end
end
