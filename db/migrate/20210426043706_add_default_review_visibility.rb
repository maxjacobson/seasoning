# frozen_string_literal: true

# A new setting for the settings page
class AddDefaultReviewVisibility < ActiveRecord::Migration[6.1]
  def change
    change_table :humans do |t|
      t.enum :default_review_visibility,
             enum_name: :visibility,
             default: "anybody",
             null: false,
             comment: <<~COMMENT.squish
               Lets people specify who they generally want to share their reviews with,
               to save them some clicking
             COMMENT
    end
  end
end
