# frozen_string_literal: true

# Starting to introduce some settings so people can configure their experience
class AddShareCurrentlyWatchingSetting < ActiveRecord::Migration[6.1]
  def change
    change_table :humans do |t|
      t.boolean :share_currently_watching,
                null: false,
                default: false,
                comment: "Whether or not to publicly display your currently watching list on the profile page"
    end
  end
end
