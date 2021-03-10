# frozen_string_literal: true

# Just making sure that there can only be one of me
class EnsureUniqueHumans < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      create unique index humans_handle_unique on humans (handle);
      create unique index humans_email_unique on humans (email);
    SQL
  end

  def down
    execute <<~SQL
      drop index humans_handle_unique;
      drop index humans_email_unique;
    SQL
  end
end
