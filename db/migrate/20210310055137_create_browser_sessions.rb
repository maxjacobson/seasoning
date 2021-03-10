# frozen_string_literal: true

# The table that stores the token that we keep in localstorage in the client side
class CreateBrowserSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :browser_sessions do |t|
      t.string :token,
               null: false,
               comment: "The token that will be kept in localstorage and included with API requests"

      t.references :human, null: false
      t.timestamp :last_seen_at,
                  null: false,
                  comment: "When the human last visited during this session"

      t.timestamp :expires_at,
                  null: false,
                  comment: "The time at which we should stop honoring the token and force them to log in again"

      t.timestamps
    end

    add_foreign_key :browser_sessions, :humans, on_delete: :cascade
  end
end
