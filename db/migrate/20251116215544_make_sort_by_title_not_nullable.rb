class MakeSortByTitleNotNullable < ActiveRecord::Migration[8.2]
  def change
    change_column_null :shows, :sort_by_title, false
  end
end
