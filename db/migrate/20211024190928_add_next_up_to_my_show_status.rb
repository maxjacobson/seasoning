# This lets people pick which, of the shows they might watch
# next, they actually plan to watch next.
#
# We may also do some automation, where shows move from
# "waiting for more" to "next up" automatically when new
# seasons are available.
class AddNextUpToMyShowStatus < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_enum_value :my_show_status, "next_up"
  end
end
