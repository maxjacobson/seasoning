# I forget why I had this, so I think I'll just drop it...
class RemoveSessionLastSeenAt < ActiveRecord::Migration[7.0]
  def change
    remove_column :browser_sessions,
                  :last_seen_at,
                  :timestamp,
                  null: false,
                  default: Time.zone.now,
                  comment: "When the human last visited during this session"
  end
end
