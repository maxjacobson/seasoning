# Making this default to true for new humans because I'm nosy,
# and people can always change it if they are privacy conscious
class ChangeDefaultShareCurrentlyWatching < ActiveRecord::Migration[7.0]
  def change
    change_column_default :humans, :share_currently_watching, from: false, to: true
  end
end
