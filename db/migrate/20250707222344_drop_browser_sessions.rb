# Drop the browser_sessions table after migrating to Rails sessions
class DropBrowserSessions < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :browser_sessions, :humans
    drop_table :browser_sessions
  end

  def down
    create_table :browser_sessions do |t|
      t.string "token", null: false, comment: "A token that is kept in the session"
      t.bigint "human_id", null: false
      t.datetime "expires_at", precision: nil, null: false,
                               comment: "When we should stop honoring the token"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["human_id"], name: "index_browser_sessions_on_human_id"
    end

    add_foreign_key :browser_sessions, :humans, on_delete: :cascade
  end
end
