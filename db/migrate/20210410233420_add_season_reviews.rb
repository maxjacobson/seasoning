# frozen_string_literal: true

# People should be able to review seasons of shows
class AddSeasonReviews < ActiveRecord::Migration[6.1]
  def change
    create_enum :visibility, %w[anybody mutuals myself]

    create_table :season_reviews do |t|
      t.references :author,
                   foreign_key: { to_table: :humans, on_delete: :cascade },
                   null: false,
                   comment: "Who wrote this review"
      t.references :season,
                   foreign_key: { on_delete: :cascade },
                   null: false,
                   comment: "Which season are they reviewing"
      t.text :body,
             null: false,
             comment: "The body of the review"

      t.integer :rating, null: true, comment: "The rating between 0 and 10 (optional)"

      t.boolean :spoilers, null: false, default: false, comment: "Whether this review contains spoilers"

      t.integer :viewing,
                null: false,
                comment: "Is this the person's first, second, third etc viewing of the season?"

      t.enum :visibility, enum_name: :visibility, default: "anybody", null: false, comment: "Who can see this review"

      t.timestamps
    end

    add_index :season_reviews, %i[author_id season_id viewing], unique: true
  end
end
