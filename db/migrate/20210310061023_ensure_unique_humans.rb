# Just making sure that there can only be one of me
class EnsureUniqueHumans < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL.squish
      create unique index humans_handle_unique on humans (handle);
      create unique index humans_email_unique on humans (email);
    SQL
  end

  def down
    execute <<~SQL.squish
      drop index humans_handle_unique;
      drop index humans_email_unique;
    SQL
  end
end
