# alter the visibility schema to remove the unused "mutuals" option
class RemoveMutualsReviewVisibilityPartTwo < ActiveRecord::Migration[8.0]
  def up
    create_enum "new_visibility", ["anybody", "myself"]

    execute <<~SQL.squish
      alter table season_reviews
        alter column visibility drop default,
        alter column visibility
          set data type new_visibility
          using visibility::text::new_visibility,
          alter column visibility set default 'anybody';


      alter table humans
        alter column default_review_visibility drop default,
        alter column default_review_visibility
          set data type new_visibility
          using default_review_visibility::text::new_visibility,
          alter column default_review_visibility set default 'anybody';
    SQL

    drop_enum "visibility"
    rename_enum "new_visibility", "visibility"
  end

  def down
    add_enum_value :visibility, "mutuals"
  end
end
