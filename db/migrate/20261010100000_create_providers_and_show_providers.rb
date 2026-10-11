class CreateProvidersAndShowProviders < ActiveRecord::Migration[8.1]
  def change
    create_table :providers do |t|
      t.string :name, null: false, comment: "e.g. Netflix, AMC+, Apple TV"
      t.integer :tmdb_provider_id, null: false, comment: "TMDB's id for the provider (their data comes from JustWatch)"
      t.string :tmdb_logo_path, comment: "Path part of the provider's logo image URL"

      t.timestamps
    end

    add_index :providers, :tmdb_provider_id, unique: true

    create_table :show_providers do |t|
      t.references :provider, null: false, foreign_key: { on_delete: :cascade },
                              comment: "Where the show can be watched"
      t.references :show, null: false, foreign_key: { on_delete: :cascade }, comment: "The show being watched"
      t.string :category, null: false,
                          comment: "How it can be watched there: flatrate, rent, buy, free, or ads"
      t.integer :display_priority, null: false, default: 0, comment: "TMDB's suggested ordering within a category"

      t.timestamps
    end

    add_index :show_providers, [:show_id, :provider_id, :category], unique: true,
                                                                    name: <<~INDEX_NAME.squish
                                                                      index_show_providers_on_show_provider_and_category
                                                                    INDEX_NAME
  end
end
