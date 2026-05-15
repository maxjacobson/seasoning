class CreateSeasonReviewLikes < ActiveRecord::Migration[8.2]
  def change
    create_table :season_review_likes do |t|
      t.bigint :human_id, null: false, comment: "Who liked the review"
      t.bigint :season_review_id, null: false, comment: "Which review was liked"
      t.timestamps

      t.index [:human_id, :season_review_id], unique: true, name: "index_season_review_likes_on_human_and_review"
      t.index :human_id
      t.index :season_review_id
    end

    add_foreign_key :season_review_likes, :humans, on_delete: :cascade
    add_foreign_key :season_review_likes, :season_reviews, on_delete: :cascade
  end
end
