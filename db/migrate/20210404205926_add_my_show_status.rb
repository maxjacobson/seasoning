# frozen_string_literal: true

# Let's go! So far we just let people add a show, but not specify why they added it
class AddMyShowStatus < ActiveRecord::Migration[6.1]
  def change
    create_enum :my_show_status, %w[might_watch currently_watching stopped_watching waiting_for_more finished]

    change_table :my_shows do |t|
      t.enum :status, enum_type: :my_show_status, default: "might_watch", null: false
    end
  end
end
