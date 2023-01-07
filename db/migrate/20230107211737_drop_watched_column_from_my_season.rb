# frozen_string_literal: true

# We don't need this column anymore now that we have watched_episode_numbers
class DropWatchedColumnFromMySeason < ActiveRecord::Migration[7.0]
  def change
    remove_column :my_seasons,
                  :watched,
                  :boolean,
                  default: false,
                  null: false,
                  comment: "Did the human watch this season yet?"
  end
end
