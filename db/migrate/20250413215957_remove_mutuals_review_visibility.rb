# Get rid of a visibility that never quite worked
class RemoveMutualsReviewVisibility < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL.squish
      update season_reviews set visibility = 'myself' where visibility = 'mutuals'
    SQL

    execute <<~SQL.squish
      update humans set default_review_visibility = 'myself'
      where default_review_visibility = 'mutuals'
    SQL
  end

  def down
    # No-op
  end
end
