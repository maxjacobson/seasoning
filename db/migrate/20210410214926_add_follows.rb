# frozen_string_literal: true

# Start keeping track of who follows whom
class AddFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.references :follower,
                   foreign_key: { to_table: :humans, on_delete: :cascade },
                   null: false,
                   comment: "Who is the person doing the following"
      t.references :followee,
                   foreign_key: { to_table: :humans, on_delete: :cascade },
                   null: false,
                   comment: "Who is the person being followed"

      t.timestamps
    end

    add_index :follows, %i[follower_id followee_id], unique: true
  end
end
