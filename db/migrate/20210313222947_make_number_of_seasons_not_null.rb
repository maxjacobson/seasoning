# We can do this now because it's such early days...
# later on we would need to do this more carefully
class MakeNumberOfSeasonsNotNull < ActiveRecord::Migration[6.1]
  def change
    Show.where(number_of_seasons: nil).destroy_all
    change_column_null :shows, :number_of_seasons, false
  end
end
