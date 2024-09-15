# Now that we've set this value, we can mark it as not nullable going forward
class MarkStillSizesAsNotNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :tmdb_api_configurations, :still_sizes, false
  end
end
