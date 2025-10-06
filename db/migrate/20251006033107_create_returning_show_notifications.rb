class CreateReturningShowNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :returning_show_notifications do |t|
      t.references :human, null: false, foreign_key: { on_delete: :cascade },
                           comment: "Which human should receive this notification"
      t.references :show, null: false, foreign_key: { on_delete: :cascade }, comment: "Which show is returning"

      t.timestamps
    end

    add_index :returning_show_notifications, [:human_id, :show_id], unique: true,
                                                                    name: <<~INDEX_NAME.squish
                                                                      index_returning_show_notifications_on_human_and_show
                                                                    INDEX_NAME
  end
end
