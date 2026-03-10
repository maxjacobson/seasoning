class RenameWaitingForMoreToWaiting < ActiveRecord::Migration[8.2]
  def change
    rename_enum_value :my_show_status, from: "waiting_for_more", to: "waiting"
  end
end
