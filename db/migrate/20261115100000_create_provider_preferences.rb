class CreateProviderPreferences < ActiveRecord::Migration[8.1]
  def change
    create_enum :provider_preference_status, ["pinned", "hidden"]

    create_table :provider_preferences do |t|
      t.references :human, null: false, foreign_key: { on_delete: :cascade },
                           comment: "Who has the preference"
      t.references :provider, null: false, foreign_key: { on_delete: :cascade },
                              comment: "The watch provider they feel a way about"
      t.enum :status, null: false, enum_type: :provider_preference_status,
                      comment: "How they feel about it: pinned or hidden"

      t.timestamps
    end

    add_index :provider_preferences, [:human_id, :provider_id], unique: true
  end
end
