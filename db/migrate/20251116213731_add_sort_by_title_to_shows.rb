class AddSortByTitleToShows < ActiveRecord::Migration[8.2]
  def change
    add_column :shows, :sort_by_title, :string,
               comment: "The show's title normalized for sorting (strips leading articles like 'The', 'A', 'An')"
  end
end
