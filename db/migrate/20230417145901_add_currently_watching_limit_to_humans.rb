# This new setting will support a new feature where humans can set their
# cap on how many shows they want to be watching at once
#
# Because... I watch too many shows and feel guilty about it!
class AddCurrentlyWatchingLimitToHumans < ActiveRecord::Migration[7.0]
  def change
    change_table :humans do |t|
      t.integer :currently_watching_limit,
                null: true,
                comment: "How many shows, at most, does this human want to watch at once?"
    end
  end
end
