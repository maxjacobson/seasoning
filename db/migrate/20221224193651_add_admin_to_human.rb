# frozen_string_literal: true

# I'm building out a simple admin page, so I want to have the ability to mark my
# human record as an admin so I can gate that page to just me
class AddAdminToHuman < ActiveRecord::Migration[7.0]
  def change
    change_table :humans do |t|
      t.boolean :admin,
                null: false,
                default: false,
                comment: <<~COMMENT.squish
                  Gives humans some extra abilities to see things like the admin stats page
                COMMENT
    end
  end
end
